import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remote_monotoring/core/controllers/session_controller.dart';
import 'package:remote_monotoring/features/Dashboard/domain/models/dashboard_model.dart';
import 'package:remote_monotoring/features/Dashboard/domain/repositories/dashboard_repository.dart';
import 'package:remote_monotoring/utils/theme/app_theme.dart';

class DashboardController extends GetxController {
  final _sessionController = Get.find<SessionController>();
  final DashboardRepository _dashboardRepository = DashboardRepository();

  final Rx<DashboarddataResponse?> dashboardData = Rx<DashboarddataResponse?>(
    null,
  );
  final RxString errorMessage = ''.obs;

  final RxBool isLoading = false.obs; // Add this line

  final RxInt selectedIndex = 0.obs;
  final RxBool isDrawerOpen = false.obs;

  final List<Map<String, dynamic>> menuItems = [
    {'title': 'Dashboard', 'icon': Icons.dashboard},
    {'title': 'Manage Devices', 'icon': Icons.devices},
    {'title': 'History', 'icon': Icons.history},
    {'title': 'Analytics', 'icon': Icons.bar_chart},
    {'title': 'Settings', 'icon': Icons.settings},
  ];

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData(); // optional if you want to call on load
  }

  void onMenuItemTapped(int index) {
    selectedIndex.value = index;

    switch (index) {
      case 0:
        break;
      case 1:
        Get.toNamed('/manageDevices');
        break;
      case 2:
        Get.toNamed('/history');
        break;
      case 3:
        Get.toNamed('/analytics');
        break;
      case 4:
        Get.toNamed('/settings');
        break;
    }
  }

  void toggleDrawer() {
    isDrawerOpen.value = !isDrawerOpen.value;
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppTheme.backgroundMedium,
        title: Text('Logout', style: AppTheme.headingSmall(Get.context!)),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTheme.bodyMedium(Get.context!),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: AppTheme.bodyMedium(
                Get.context!,
              ).copyWith(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await _sessionController.clearSession();
              Get.offAllNamed('/login');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: Text('Logout', style: AppTheme.bodyMedium(Get.context!)),
          ),
        ],
      ),
    );
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _dashboardRepository.fetchDashboardDataWithToken(
        _sessionController.token.value,
      );

      if (response.error) {
        errorMessage.value = response.message;
        Get.snackbar(
          'Error',
          errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        dashboardData.value = response;
        // Debug information
        print('Dashboard data loaded successfully:');
        print('Total devices: ${response.deviceListTotalCount}');
        print('Active devices: ${response.deviceListActiveCount}');
        print('Inactive devices: ${response.deviceListDeactiveCount}');
      }
    } catch (e) {
      errorMessage.value = 'Failed to load dashboard data: ${e.toString()}';
      print('Error loading dashboard data: $e');
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
