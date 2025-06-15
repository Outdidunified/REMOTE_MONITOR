

import 'package:remote_monotoring/core/core.dart';
import 'package:remote_monotoring/core/services/endpoint.dart';

class AuthUrl {
  static final Endpoint registeraccount = Endpoint(
      url: '${RemoteMonitoringCore.baseUrl}/iotDashboard/userRegister', method: 'POST');
  static final Endpoint loginaccount = Endpoint(
      url: '${RemoteMonitoringCore.baseUrl}/iotDashboard/userLogin', method: 'POST');
  static final Endpoint getotp = Endpoint(
      url: '${RemoteMonitoringCore.baseUrl}/iotDashboard/forgetPassword', method: 'POST');
  static final Endpoint verifyotp = Endpoint(
      url: '${RemoteMonitoringCore.baseUrl}/iotDashboard/otpVerify', method: 'POST');
  static final Endpoint Updatepassword = Endpoint(
      url: '${RemoteMonitoringCore.baseUrl}/iotDashboard/updatePassword', method: 'POST');

}
