import 'package:flutter/foundation.dart';
import 'package:remote_monotoring/features/History/data/api.dart';
import 'package:remote_monotoring/features/History/domain/models/history_model.dart';

class HistoryRepositories {
  final HistoryPageApiCall _api = HistoryPageApiCall();

  Future<FetchdevicehistoryResponse> fetchdevicehistory(String token) async {
    try {
      final Map<String, dynamic> responseJson = await _api.FetchDeviceHistory(token);

      // Add null checks before parsing
      if (responseJson == null) {
        throw Exception('Null response received from API');
      }

      return FetchdevicehistoryResponse.fromJson(responseJson);
    } catch (e) {
      debugPrint('repo error : $e');
      rethrow;
    }
  }
}
