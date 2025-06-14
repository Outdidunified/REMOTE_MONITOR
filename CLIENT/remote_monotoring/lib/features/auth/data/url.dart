

import 'package:remote_monotoring/core/core.dart';
import 'package:remote_monotoring/core/services/endpoint.dart';

class AuthUrl {
  static final Endpoint registeraccount = Endpoint(
      url: '${RemoteMonitoringCore.baseUrl}/iotDashboard/userRegister', method: 'POST');
  static final Endpoint loginaccount = Endpoint(
      url: '${RemoteMonitoringCore.baseUrl}/iotDashboard/userLogin', method: 'POST');

}
