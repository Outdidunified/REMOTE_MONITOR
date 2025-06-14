const { connectToDatabase } = require('../config/db');
const logger = require('../utils/logger');
const { ObjectId } = require('mongodb');
const jwt = require('jsonwebtoken');
const JWT_SECRET = process.env.JWT_SECRET || 'default_secret_key';
const nodemailer = require('nodemailer');

// Email transporter setup
const transporter = nodemailer.createTransport({
    host: 'smtppro.zoho.in', // SMTP server address
    port: 465, // Use 465 for SSL, 587 for TLS
    secure: true, // Use SSL (true) or TLS (false)
    auth: {
        user: 'kesavan@outdidtech.com', // Your email address
        pass: 'qShPZ1czL5Gm', // Your email password
    },
});

async function sendEmail(to, subject, text, html) {
    try {
        const info = await transporter.sendMail({
            from: `Remote Monitor <kesavan@outdidtech.com>`,
            to,
            subject,
            text,
            html,
        });
        console.log('Message sent: %s', info.messageId);
        return true;
    } catch (error) {
        console.error('Error sending email:', error);
        return false;
    }
}

// Send OTP email
async function sendForgetEmail(email, otd) {
    try {
        const subject = 'Your Forget Password OTP';
        const text = `Hi remote monitor user,\n\nYour OTP to reset your password is: ${otd}`;

        const html = `
            <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border-radius: 10px; background-color: #f9f9f9; border: 1px solid #ddd;">
                <h2 style="color: #333;">Hi Remote Monitor User,</h2>
                <p style="font-size: 16px; color: #555;">
                    Your password reset OTP is: <strong style="color: #000;">${otd}</strong>
                </p>
                <p style="font-size: 16px; color: #555;">
                    This OTP is valid for 10 minutes. Please do not share it with anyone.
                </p>
                <p style="color: #555;">Thank you for choosing <strong>Remote monitor</strong>!</p>
                <p style="font-size: 14px; color: #888; text-align: center; margin-top: 30px; border-top: 1px solid #ddd; padding-top: 10px;">
                    This is an automated message from remote monitor.
                </p>
            </div>
        `;

        return await sendEmail(email, subject, text, html); // ✅ Return value
    } catch (error) {
        console.error('Error in sendForgetEmail:', error);
        return false;
    }
}

function isValidPassword(password) {
    const regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$/;
    return regex.test(password);
}

function isValidForgetPasswordOtp(forget_password_otp) {
    const regex = /^\d{6}$/;  // Matches exactly 6 digits
    return regex.test(String(forget_password_otp));
}

// controller user register
const userRegister = async (req, res) => {
    const { name, email, phone, password } = req.body;

    if (!email || !name || !phone || !password) {
        return res.status(400).json({ error: true, status: false, message: 'All fields are required.' });
    }

    if (!isValidPassword(password)) {
        return res.status(400).json({
            error: true,
            status: false,
            message: 'Password must be at least 8 characters long, include uppercase, lowercase, number, and special character.'
        });
    }

    try {
        const db = await connectToDatabase();
        const usersCollection = db.collection('users');

        const existingUser = await usersCollection.findOne({ email });
        if (existingUser) {
            return res.status(400).json({ error: true, status: false, message: 'Email already exists.' });
        }

        const lastUser = await usersCollection
            .find({})
            .sort({ user_id: -1 })
            .limit(1)
            .toArray();

        const user_id = lastUser.length > 0 ? lastUser[0].user_id + 1 : 1;

        const createDate = new Date();
        const createdBy = email;
        const role_id = 1;
        const role_name = 'user';

        const newUser = {
            user_id,
            name,
            email,
            phone,
            password,
            createDate,
            createdBy,
            role_id,
            role_name,
            status: true,
        };

        await usersCollection.insertOne(newUser);

        return res.status(200).json({ error: false, status: true, message: 'User registered successfully.' });

    } catch (error) {
        console.error('Registration error:', error);
        return res.status(500).json({ error: true, status: false, error: 'Internal Server Error' });
    }
};

// controller user login
const userLogin = async (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({ error: true, status: false, message: 'All fields are required.' });
    }

    if (!isValidPassword(password)) {
        return res.status(400).json({
            error: true,
            status: false,
            message: 'Password must be at least 8 characters long, include uppercase, lowercase, number, and special character.'
        });
    }

    try {
        const db = await connectToDatabase();
        const usersCollection = db.collection('users');

        const user = await usersCollection.findOne({ email });

        if (!user) {
            return res.status(404).json({ error: true, status: false, message: 'Email not registered.' });
        }

        if (user.password !== password) {
            return res.status(401).json({ error: true, status: false, message: 'Incorrect password.' });
        }

        if (!user.status) {
            return res.status(403).json({ error: true, status: false, message: 'Account is deactivated. Please contact support.' });
        }

        const payload = {
            userId: user._id,
            email: user.email,
            role_id: user.role_id,
        };

        const token = jwt.sign(payload, JWT_SECRET);

        // const token = jwt.sign(payload, JWT_SECRET, { expiresIn: '1h' }); // ⏱️ Token expires in 1 hour

        const { password: _, ...userWithoutPassword } = user;

        return res.status(200).json({
            error: false,
            status: true,
            message: 'Login successful.',
            token,
            user: userWithoutPassword,
        });

    } catch (error) {
        console.error('Login error:', error);
        return res.status(500).json({
            error: true,
            status: false,
            message: 'Failed to login, please try again.',
        });
    }
};

// controller forget password
const forgetPassword = async (req, res) => {
    const { email } = req.body;

    if (!email) {
        return res.status(400).json({ error: true, status: false, message: 'Missing email' });
    }

    try {
        const db = await connectToDatabase();
        const usersCollection = db.collection('users');

        // Match using email
        const user = await usersCollection.findOne({
            email: email
        });

        if (!user) {
            return res.status(404).json({ error: true, status: false, message: 'Email not found.' });
        }

        // Generate 6-digit OTP
        const otp = Math.floor(100000 + Math.random() * 900000);
        const expiryDate = new Date(Date.now() + 10 * 60 * 1000); // 10 minutes from now

        // Send email
        const emailSent = await sendForgetEmail(email, otp);

        if (!emailSent) {
            return res.status(500).json({ error: true, status: false, message: 'Failed to send OTP email.' });
        }

        // Update user document with OTP and expiry
        await usersCollection.updateOne(
            { email },
            {
                $set: {
                    forget_password_otp: otp,
                    otp_created_at: new Date(),
                    otp_expiry: expiryDate
                }
            }
        );

        return res.status(200).json({ error: false, status: true, message: 'OTP sent successfully.' });

    } catch (err) {
        console.error('Error in forgetPassword:', err);
        return res.status(500).json({ error: true, status: false, message: 'Internal server error.' });
    }
};

// controller otp verify
const otpVerify = async (req, res) => {
    const { email, forget_password_otp } = req.body;

    try {
        if (!email || !forget_password_otp) {
            return res.status(400).json({
                error: true,
                status: false,
                message: 'Both email and OTP are required'
            });
        }

        const db = await connectToDatabase();
        const usersCollection = db.collection("users");

        const user = await usersCollection.findOne({ email });

        if (!user) {
            return res.status(404).json({
                error: true,
                status: false,
                message: 'User not found'
            });
        }

        if (!isValidForgetPasswordOtp(forget_password_otp)) {
            return res.status(400).json({
                error: true,
                status: false,
                message: 'OTP must be exactly 6 digits.'
            });
        }

        // Convert OTP to number (if sent as string)
        const otpFromClient = Number(forget_password_otp);

        if (user.forget_password_otp !== otpFromClient) {
            return res.status(400).json({
                error: true,
                status: false,
                message: 'OTP does not match'
            });
        }

        const currentTime = new Date();
        if (user.otp_expiry && currentTime > new Date(user.otp_expiry)) {
            return res.status(400).json({
                error: true,
                status: false,
                message: 'OTP has expired'
            });
        }

        // Optional: Clear OTP after successful verification
        await usersCollection.updateOne(
            { email },
            {
                $unset: {
                    forget_password_otp: "",
                    otp_created_at: "",
                    otp_expiry: ""
                }
            }
        );

        return res.status(200).json({
            error: false,
            status: true,
            message: 'OTP verified successfully'
        });

    } catch (error) {
        console.error('Error in otpVerify:', error);
        return res.status(500).json({
            error: true,
            status: false,
            message: 'Internal Server Error'
        });
    }
};

// controller update password
const updatePassword = async (req, res) => {
    const { email, password } = req.body;

    try {
        if (!email || !password) {
            return res.status(400).json({
                error: true,
                status: false,
                message: 'All fields (email, password) are required'
            });
        }

        if (!isValidPassword(password)) {
            return res.status(400).json({
                error: true,
                status: false,
                message: 'Password must be at least 8 characters long, include uppercase, lowercase, number, and special character.'
            });
        }

        const db = await connectToDatabase();
        const usersCollection = db.collection("users");

        const existingUser = await usersCollection.findOne({ email });

        if (!existingUser) {
            return res.status(404).json({
                error: true,
                status: false,
                message: 'User not found'
            });
        }

        const updateResult = await usersCollection.updateOne(
            { email },
            {
                $set: {
                    password: password,
                    modifiedBy: email,
                    modifiedDate: new Date(),
                }
            }
        );

        if (updateResult.modifiedCount === 0) {
            return res.status(500).json({
                error: true,
                status: false,
                message: 'Failed to update password'
            });
        }

        return res.status(200).json({
            error: false,
            status: true,
            message: 'Password updated successfully'
        });

    } catch (error) {
        console.error('Error in updatePassword:', error);
        return res.status(500).json({
            error: true,
            status: false,
            message: 'Internal Server Error'
        });
    }
};

// controller fetch user profile
const fetchUserProfile = async (req, res) => {
    const { user_id } = req.body;

    try {
        const db = await connectToDatabase();
        const usersCollection = db.collection("users");

        // Correct syntax for querying by user_id
        const user = await usersCollection.findOne({ user_id: parseInt(user_id) });

        if (!user) {
            return res.status(404).json({ error: true, status: false, message: 'User not found' });
        }

        const { ...sanitizedProfile } = user;

        return res.status(200).json({ error: false, status: true, data: sanitizedProfile });

    } catch (error) {
        console.error('Error in fetch user profile controller:', error);
        logger?.error?.(error);
        return res.status(500).json({ error: true, status: false, message: 'Internal Server Error' });
    }
};

// controller update user profile
const updateUserProfile = async (req, res) => {
    const { user_id, name, phone, password, modifiedBy, status } = req.body;

    try {
        // Validate all fields
        if (
            user_id === undefined ||
            !name ||
            !phone ||
            !password ||
            !modifiedBy
        ) {
            return res.status(400).json({
                error: true,
                status: false,
                message: 'All fields (user_id, name, phone, password, modifiedBy) are required'
            });
        }

        const db = await connectToDatabase();
        const usersCollection = db.collection("users");

        const userIdInt = parseInt(user_id);

        // Check if user exists
        const existingUser = await usersCollection.findOne({ user_id: userIdInt });
        if (!existingUser) {
            return res.status(404).json({ error: true, status: false, message: 'User not found' });
        }

        if (!isValidPassword(password)) {
            return res.status(400).json({
                error: true,
                status: false,
                message: 'Password must be at least 8 characters long, include uppercase, lowercase, number, and special character.'
            });
        }

        // Perform update
        const updateResult = await usersCollection.updateOne(
            { user_id: userIdInt },
            {
                $set: {
                    name,
                    phone: parseInt(phone),
                    password: password,
                    modifiedBy: modifiedBy,
                    modifiedDate: new Date(),
                }
            }
        );

        if (updateResult.matchedCount === 0 || updateResult.modifiedCount === 0) {
            return res.status(500).json({ error: true, status: false, message: 'Failed to update user profile' });
        }

        return res.status(200).json({
            error: false,
            status: true,
            message: 'User profile updated successfully',
            data: {
                user_id: userIdInt,
                password,
                name,
                phone,
            }
        });

    } catch (error) {
        console.error('Error in update user profile controller:', error);
        logger?.error?.(error);
        return res.status(500).json({ error: true, status: false, message: 'Internal Server Error' });
    }
};

// controller add device
const addDevice = async (req, res) => {
    const { user_id, device_id, createBy } = req.body;

    if (!user_id || !device_id || !createBy) {
        return res.status(400).json({
            error: true,
            status: false,
            message: 'Missing required fields: user_id, device_id, createBy'
        });
    }

    try {
        const db = await connectToDatabase();
        const deviceList = db.collection("device_list");

        // Check for duplicate device_id
        const existingDevice = await deviceList.findOne({ device_id });

        if (existingDevice) {
            return res.status(400).json({
                error: true,
                status: false,
                message: 'Device ID already exist. Cannot add duplicate device.'
            });
        }

        const newDevice = {
            user_id: parseInt(user_id),
            device_id,
            createBy,
            createDate: new Date(),
            status: true
        };

        await deviceList.insertOne(newDevice);

        res.status(200).json({
            error: false,
            status: true,
            message: 'Added device successfully',
            data: newDevice
        });

    } catch (err) {
        console.error("Error in add device:", err);
        logger?.error?.(err);
        res.status(500).json({
            error: true,
            status: false,
            message: 'Internal Server Error'
        });
    }
};

// controller fetch device
const fetchDevice = async (req, res) => {
    try {
        const db = await connectToDatabase();
        const deviceCollection = db.collection("device_list");

        // Fetch all device records
        const device = await deviceCollection.find({}).toArray();

        if (!device || device.length === 0) {
            return res.status(404).json({ error: true, status: false, message: 'No device data found.' });
        }

        return res.status(200).json({ error: false, status: true, data: device });

    } catch (error) {
        console.error('Error in fetch device controller:', error);
        logger?.error?.(error);
        return res.status(500).json({ error: true, status: false, message: 'Internal Server Error' });
    }
};

// controller update device
const updateDevice = async (req, res) => {
    const { user_id, device_id, modifiedBy, status } = req.body;

    if (!user_id || !device_id || !modifiedBy || typeof status !== 'boolean') {
        return res.status(400).json({
            error: true,
            status: false,
            message: 'Missing required fields or invalid status value.'
        });
    }

    try {
        const db = await connectToDatabase();
        const deviceList = db.collection("device_list");

        // Check if device exists
        const existingDevice = await deviceList.findOne({ device_id });

        if (!existingDevice) {
            return res.status(404).json({
                error: true,
                status: false,
                message: 'Device ID not found in device_list.'
            });
        }

        // Perform update
        const updated = await deviceList.updateOne(
            { device_id },
            {
                $set: {
                    status,
                    modifiedBy,
                    modifiedDate: new Date()
                }
            }
        );

        res.status(200).json({
            error: false,
            status: true,
            message: 'Device updated successfully',
            // updatedCount: updated.modifiedCount
        });

    } catch (err) {
        console.error("Error in updateDevice:", err);
        logger?.error?.(err);
        res.status(500).json({
            error: true,
            status: false,
            message: 'Internal Server Error'
        });
    }
};

// controller fetch device history
const fetchDeviceHistory = async (req, res) => {
    try {
        const db = await connectToDatabase();
        const deviceHistoryCollection = db.collection("device_history");

        // Fetch all device history records
        const deviceHistory = await deviceHistoryCollection.find({}).toArray();

        if (!deviceHistory || deviceHistory.length === 0) {
            return res.status(404).json({ error: true, status: false, message: 'No device data found.' });
        }

        return res.status(200).json({ error: false, status: true, data: deviceHistory });

    } catch (error) {
        console.error('Error in fetch device history controller:', error);
        logger?.error?.(error);
        return res.status(500).json({ error: true, status: false, message: 'Internal Server Error' });
    }
};

// controller fetch dashboard data
const fetchDashboardData = async (req, res) => {
    try {
        const db = await connectToDatabase();
        const deviceListCollection = db.collection("device_list");
        const deviceHistoryCollection = db.collection("device_history");

        // Fetch all device_list records
        const deviceList = await deviceListCollection.find({}).toArray();
        const deviceListTotalCount = deviceList.length;
        const deviceListActiveCount = deviceList.filter(d => d.status === true).length;
        const deviceListDeactiveCount = deviceList.filter(d => d.status === false).length;

        // Fetch all device_history records
        const deviceHistory = await deviceHistoryCollection.find({}).toArray();
        const deviceHistoryTotalCount = deviceHistory.length;
        const deviceHistoryActiveCount = deviceHistory.filter(d => d.status === true).length;
        const deviceHistoryDeactiveCount = deviceHistory.filter(d => d.status === false).length;

        return res.status(200).json({
            error: false,
            status: true,
            message: 'Dashboard data fetched successfully.',
            data: {
                deviceListTotalCount,
                deviceListActiveCount,
                deviceListDeactiveCount,
                deviceList,

                deviceHistoryTotalCount,
                deviceHistoryActiveCount,
                deviceHistoryDeactiveCount,
                deviceHistory,
            }
        });

    } catch (error) {
        console.error('Error in fetchDashboardData controller:', error);
        logger?.error?.(error);
        return res.status(500).json({
            error: true,
            status: false,
            message: 'Internal Server Error'
        });
    }
};

module.exports = {
    userRegister, userLogin, forgetPassword, otpVerify, updatePassword, fetchDashboardData, fetchUserProfile, updateUserProfile, addDevice, fetchDevice, updateDevice, fetchDeviceHistory
};
