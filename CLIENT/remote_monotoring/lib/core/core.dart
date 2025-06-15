import 'package:flutter/foundation.dart';

class RemoteMonitoringCore {
  // Define base URLs for each environment
  static const String prodBaseUrl = 'http://192.168.29.222:6767';
  // static const String prodBaseUrl = 'http://172.235.29.67:4444'; //uatprod
  static const String devBaseUrl = 'http://192.168.29.222:6767';
  // static const String testingBaseUrl = 'http://192.168.1.25:3003';
  static const String testingBaseUrl = 'http://192.168.29.222:6767';

  // Define WebSocket URLs for each environment
  static const String prodWsUrl = 'ws://192.168.1.12:7002';
  // static const String prodWsUrl = 'ws://172.235.29.67:7002'; //uatprod
  static const String devWsUrl = 'ws://192.168.1.12:7004';
  // static const String testingWsUrl = 'ws://192.168.1.25:7004';
  static const String testingWsUrl = 'ws://192.168.1.12:7002';

  // Dynamically select URLs based on the environment
  static final String baseUrl = _getBaseUrl();
  static final String webSocketUrl = _getWebSocketUrl();

  // Private method to determine the base URL
  static String _getBaseUrl() {
    if (kDebugMode) {
      return testingBaseUrl;
    } else if (kProfileMode) {
      return devBaseUrl;
    } else if (kReleaseMode) {
      return prodBaseUrl;
    }
    return prodBaseUrl;
  }

  // Private method to determine WebSocket URL
  static String _getWebSocketUrl() {
    if (kDebugMode) {
      return testingWsUrl;
    } else if (kProfileMode) {
      return devWsUrl;
    } else if (kReleaseMode) {
      return prodWsUrl;
    }
    return prodWsUrl;
  }

  // Helper method to get charging-specific WebSocket URL
  static String getMonitoringWebSocketUrl(String chargerId, int connectorId) {
    return '$webSocketUrl/charging/$chargerId/$connectorId';
  }
}
