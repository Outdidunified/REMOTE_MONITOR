

import 'package:remote_monotoring/core/core.dart';
import 'package:remote_monotoring/core/services/endpoint.dart';

class SettingsUrl {
  static final Endpoint fetchUserProfile = Endpoint(
      url: '${RemoteMonitoringCore.baseUrl}/iotDashboard/fetchUserProfile', method: 'POST');
  static final Endpoint updateUserProfile = Endpoint(
      url: '${RemoteMonitoringCore.baseUrl}/iotDashboard/updateUserProfile', method: 'POST');

}
