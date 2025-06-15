import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remote_monotoring/core/controllers/session_controller.dart';
import 'package:remote_monotoring/utils/theme/app_theme.dart';

class DashboardController extends GetxController {
  final _sessionController = Get.find<SessionController>();

  final RxInt selectedIndex = 0.obs;
  final RxBool isDrawerOpen = false.obs;

  final List<Map<String, dynamic>> menuItems = [
    {'title': 'Dashboard', 'icon': Icons.dashboard},
    {'title': ' Manage Devices', 'icon': Icons.devices},
    {'title': 'History', 'icon': Icons.history},
    {'title': 'Analytics', 'icon': Icons.bar_chart},
    {'title': 'Settings', 'icon': Icons.settings},
  ];

  @override
  void onInit() {
    super.onInit();
    print('====== Session Controller Details ======');
    print('Username: ${_sessionController.username.value}');
    print('Email: ${_sessionController.emailId.value}');
    print('Token: ${_sessionController.token.value}');
    print('Is Logged In: ${_sessionController.isLoggedIn.value}');
    print('=======================================');
  }

  void onMenuItemTapped(int index) {
    selectedIndex.value = index;

    // Navigate to the corresponding page based on the selected index
    switch (index) {
      case 0: // Dashboard
        // Already on dashboard, no navigation needed
        break;
      case 1: // Manage Devices
        Get.toNamed('/manageDevices');
        break;
      case 2: // History
        Get.toNamed('/history');
        break;
      case 3: // Analytics
        Get.toNamed('/analytics');
        break;
      case 4: // Settings
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
              Get.back(); // Close the dialog
              await _sessionController.clearSession(); // Clear session
              Get.offAllNamed(
                '/login',
              ); // Navigate to login page and clear all routes
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: Text('Logout', style: AppTheme.bodyMedium(Get.context!)),
          ),
        ],
      ),
    );
  }
}
