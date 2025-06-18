import 'package:flutter/foundation.dart';
import 'package:remote_monotoring/core/services/base_api_service.dart';
import 'package:remote_monotoring/features/History/data/url.dart';

class HistoryPageApiCall extends BaseApiService {

  Future<Map<String, dynamic>> FetchDeviceHistory(String token) async {
    debugPrint('🛰️ Hitting URL: ${Historypageurl.fetchDeviceHistory.url}');

    final result = await makeRequest<Map<String, dynamic>>(
      url: Historypageurl.fetchDeviceHistory.url,
      method: Historypageurl.fetchDeviceHistory.method,
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
