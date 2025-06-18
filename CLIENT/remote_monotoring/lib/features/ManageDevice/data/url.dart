

import 'package:remote_monotoring/core/core.dart';
import 'package:remote_monotoring/core/services/endpoint.dart';

class ManageDeviceUrl {
  static final Endpoint fetchDevice = Endpoint(
      url: '${RemoteMonitoringCore.baseUrl}/iotDashboard/fetchDevice', method: 'GET');
  static final Endpoint addDevice = Endpoint(
      url: '${RemoteMonitoringCore.baseUrl}/iotDashboard/addDevice', method: 'POST');
  static final Endpoint updatedevicestatus = Endpoint(
      url: '${RemoteMonitoringCore.baseUrl}/iotDashboard/updateDevice', method: 'POST');
}
