import 'package:remote_monotoring/core/core.dart';
import 'package:remote_monotoring/core/services/endpoint.dart';

class Historypageurl {
  static final Endpoint fetchDeviceHistory = Endpoint(
      url: '${RemoteMonitoringCore.baseUrl}/iotDashboard/fetchDeviceHistory', method: 'GET');

}
