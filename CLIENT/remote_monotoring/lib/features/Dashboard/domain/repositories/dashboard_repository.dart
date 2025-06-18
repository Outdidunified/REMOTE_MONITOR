import 'package:remote_monotoring/features/Dashboard/data/api.dart';
import 'package:remote_monotoring/features/Dashboard/domain/models/dashboard_model.dart';

class DashboardRepository {
  final DashboardApiCalls _api = DashboardApiCalls();

  Future<DashboarddataResponse> fetchDashboardDataWithToken(token) async {
    try {
      final responseJson = await _api.FetchDashboardData(token);
      print('Raw API response: $responseJson');
      return DashboarddataResponse.fromJson(responseJson);
    } catch (e) {
      print('Error in repository: $e');
      rethrow;
    }
  }
}
