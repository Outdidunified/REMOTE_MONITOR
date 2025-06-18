

import 'package:flutter/foundation.dart';
import 'package:remote_monotoring/core/services/base_api_service.dart';
import 'package:remote_monotoring/features/ManageDevice/data/url.dart';

class DashboardApiCalls extends BaseApiService {
  Future<Map<String, dynamic>> FetchDashboardData(String token) async {
    debugPrint('🛰️ Hitting URL: ${ManageDeviceUrl.fetchDevice.url}');

    final result = await makeRequest<Map<String, dynamic>>(
      url: ManageDeviceUrl.fetchDevice.url,
      method: ManageDeviceUrl.fetchDevice.method,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      responseParser: (data) => data as Map<String, dynamic>,
    );

    debugPrint('🔽 Final Parsed Response => $result');
    return result;
  }


}
