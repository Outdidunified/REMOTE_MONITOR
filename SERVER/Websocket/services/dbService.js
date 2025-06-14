// services/dbService.js
const db_conn = require('../../config/db');
const logger = require('../../utils/logger');
let db;

const connectToDatabase = async () => {
    try {
        if (!db) {
            db = await db_conn.connectToDatabase();
        }
        return db;
    } catch (error) {
        logger.loggerError(`Failed to connect to database: ${error.message}`);
        throw error;
    }
};

// Check if device exists in product_list table (not 'devices')
const isDeviceIdValid = async (deviceId) => {
    const db = await connectToDatabase();
    const device = await db.collection('device_list').findOne({ device_id: deviceId, status: true });
    return !!device;
};

const saveData = async (data) => {
    const db = await connectToDatabase();
    await db.collection('device_history').insertOne(data);
    logger.loggerInfo('Data saved to DB');
};

module.exports = { isDeviceIdValid, saveData };
