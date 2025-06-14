const WebSocket = require('ws');
const { isDeviceIdValid, saveData } = require('./services/dbService');
const logger = require('../utils/logger');

let deviceSocket = null;
let reconnectTimeout = null;
let heartbeatTimeout = null;

const startDeviceSocket = (frontendSocketRef) => {
    const remoteURL = 'ws://192.168.1.222:6767/deviceData';

    logger.info(`Connecting to external device WebSocket: ${remoteURL}`);
    console.log(`Connecting to external device WebSocket: ${remoteURL}`);
    deviceSocket = new WebSocket(remoteURL);

    const resetHeartbeat = () => {
        clearTimeout(heartbeatTimeout);
        heartbeatTimeout = setTimeout(() => {
            logger.warn('Heartbeat timeout. Closing socket.');
            deviceSocket.terminate();
        }, 60000);
    };

    deviceSocket.on('open', () => {
        logger.info('Connected to external device WebSocket');
        resetHeartbeat();
    });

    deviceSocket.on('message', async (message) => {
        resetHeartbeat();
        logger.info(`Received message from device WS: ${message}`);

        console.log(`Received message from device WS: ${message}`);
        try {
            const data = JSON.parse(message);
            const { device_id } = data;

            if (!device_id) {
                logger.warn('device_id missing');
                console.log('device_id missing');
                return;
            }

            const isValid = await isDeviceIdValid(device_id);

            if (isValid) {
                await saveData(data);
                logger.info(`Data saved from device: ${device_id}`);
                console.log(`Data saved from device: ${device_id}`);
                if (frontendSocketRef.current && frontendSocketRef.current.readyState === WebSocket.OPEN) {
                    frontendSocketRef.current.send(JSON.stringify(data));
                }
            } else {
                logger.warn(`Invalid device_id: ${device_id}`);
                console.log(`Invalid device_id: ${device_id}`);
            }

        } catch (err) {
            logger.error(`Failed to process device WS message: ${err.message}`);
            console.log(`Failed to process device WS message: ${err.message}`);
        }
    });

    deviceSocket.on('close', () => {
        logger.warn('Device WebSocket closed. Reconnecting...');
        console.log('Device WebSocket closed. Reconnecting...');
        clearTimeout(heartbeatTimeout);
        reconnectTimeout = setTimeout(() => startDeviceSocket(frontendSocketRef), 5000);
    });

    deviceSocket.on('error', (err) => {
        logger.error(`Device WS error: ${err.message}`);
        console.log(`Device WS error: ${err.message}`);
        deviceSocket.close();
    });
};

module.exports = { startDeviceSocket };
