require('dotenv').config();
const express = require('express');
const http = require('http');
const helmet = require('helmet');
const cors = require('cors');
const rateLimit = require('express-rate-limit');
const logger = require('./utils/logger');

// Import Routes
const IotDashboardRoute = require('./routes/IotDashboardRoute');

const { setupWebSocketServer, frontendSocketRef } = require('./Websocket/websocketServer');
const { startDeviceSocket } = require('./Websocket/websocketClient');
const db_conn = require('./config/db');

const app = express();
app.use(helmet());
app.use(cors({ origin: '*', credentials: true }));
app.use(express.json());

const limiter = rateLimit({ windowMs: 15 * 60 * 1000, max: 100 });

// Register Routes
app.use('/iotDashboard', IotDashboardRoute);

app.use(limiter);

const HTTP_PORT = process.env.HTTP_PORT || 6767;
const server = http.createServer(app);

(async () => {
    try {
        await db_conn.connectToDatabase();
        console.log('MongoDB connected');

        server.listen(HTTP_PORT, () => {
            console.log(`HTTP Server running on port ${HTTP_PORT}`);
            logger.info(`HTTP Server running on port ${HTTP_PORT}`);

            setupWebSocketServer(server);
            console.log('WebSocket server ready');

            startDeviceSocket(frontendSocketRef);
            console.log('Attempting device WebSocket connection...');
        });

    } catch (err) {
        console.error('MongoDB connection failed:', err.message);
        process.exit(1);
    }
})();
