import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:remote_monotoring/core/controllers/base_controller.dart';
import 'package:remote_monotoring/core/controllers/session_controller.dart';
import 'package:remote_monotoring/features/History/domain/models/history_model.dart';
import 'package:remote_monotoring/features/History/domain/repositories/history_repositories.dart';

class HistoryPageControllers extends BaseController {
  final HistoryRepositories _historyRepository = HistoryRepositories();

  // Reactive state variables
  final Rx<FetchdevicehistoryResponse?> historyData =
      Rx<FetchdevicehistoryResponse?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    fetchDeviceHistory();
    super.onInit();
  }

  Future<void> fetchDeviceHistory() async {
    try {
      isLoading(true);
      errorMessage('');

      // Get token from your session controller
      final token = Get.find<SessionController>().token.value;

      if (token.isEmpty) {
        throw Exception('Authentication token not available');
      }

      final response = await _historyRepository.fetchdevicehistory(token);

      if (response.error == false) {
        historyData(response);
      } else {
        throw Exception(response.message ?? 'Failed to fetch history data');
      }
    } catch (e) {
      errorMessage(e.toString());
      debugPrint('Controller error: $e');
    } finally {
      isLoading(false);
    }
  }
}
