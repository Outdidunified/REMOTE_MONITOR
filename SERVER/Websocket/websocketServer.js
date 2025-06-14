require('dotenv').config();
const WebSocket = require('ws');
const { isDeviceIdValid, saveData } = require('./services/dbService');
const logger = require('../utils/logger');

const frontendSocketRef = { current: null };

const setupWebSocketServer = (server) => {
    const wss = new WebSocket.Server({ server });

    wss.on('connection', (ws, req) => {
        const path = req.url;
        const connectTime = new Date().toISOString();
        let validatedDeviceId = null;

        logger.info(`[CONNECT] ${connectTime} - Path: ${path}`);
        console.log(`[CONNECT] ${connectTime} - Path: ${path}`);

        // Frontend connection
        if (path === '/frontend') {
            frontendSocketRef.current = ws;
            logger.info(`[FRONTEND CONNECTED] ${connectTime}`);
            ws.on('close', () => {
                frontendSocketRef.current = null;
                logger.info(`[FRONTEND DISCONNECTED] ${new Date().toISOString()}`);
            });
            return;
        }

        // Generic timeout
        let timeoutHandle = setTimeout(() => {
            logger.warn(`[TIMEOUT] No device_id received`);
            ws.close(4000, 'Timeout: device_id not received');
        }, 30000);

        ws.on('message', async (message) => {
            clearTimeout(timeoutHandle);
            const receiveTime = new Date().toISOString();

            try {
                const data = JSON.parse(message);
                const { device_id } = data;

                if (!device_id) {
                    logger.warn(`[REJECT] ${receiveTime} - Missing device_id`);
                    ws.close(1008, 'device_id required in payload');
                    return;
                }

                // First-time validation
                if (!validatedDeviceId) {
                    const isValid = await isDeviceIdValid(device_id);
                    if (!isValid) {
                        logger.warn(`[REJECT] ${receiveTime} - Invalid device_id: ${device_id}`);
                        ws.close(1008, 'Invalid device_id');
                        return;
                    }
                    validatedDeviceId = device_id;
                    logger.info(`[DEVICE VALIDATED] ${receiveTime} - device_id: ${device_id}`);
                }

                // Check for spoofing
                if (device_id !== validatedDeviceId) {
                    logger.warn(`[MISMATCH] ${receiveTime} - Expected: ${validatedDeviceId}, Got: ${device_id}`);
                    return;
                }

                // Save and broadcast
                await saveData(data);
                logger.info(`[DATA SAVED] ${receiveTime} - device_id: ${device_id} - Payload: ${message}`);

                if (
                    frontendSocketRef.current &&
                    frontendSocketRef.current.readyState === WebSocket.OPEN
                ) {
                    frontendSocketRef.current.send(JSON.stringify(data));
                }

            } catch (err) {
                logger.error(`[PARSE ERROR] ${receiveTime} - ${err.message}`);
            }

            timeoutHandle = setTimeout(() => {
                logger.warn(`[TIMEOUT] Idle connection: ${validatedDeviceId}`);
                ws.close(4000, 'Timeout: No activity');
            }, 60000);
        });

        ws.on('close', () => {
            clearTimeout(timeoutHandle);
            const closeTime = new Date().toISOString();
            logger.info(`[DISCONNECT] ${closeTime} - device_id: ${validatedDeviceId || 'unknown'}`);
        });
    });

    logger.info('WebSocket server initialized');
};

module.exports = { setupWebSocketServer, frontendSocketRef };
