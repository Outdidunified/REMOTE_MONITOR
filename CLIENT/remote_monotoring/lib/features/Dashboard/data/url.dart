

import 'package:remote_monotoring/core/core.dart';
import 'package:remote_monotoring/core/services/endpoint.dart';

class DashboardUrl {
  static final Endpoint fetchdashboardata = Endpoint(
      url: '${RemoteMonitoringCore.baseUrl}/iotDashboard/fetchDashboardData', method: 'GET');
}
