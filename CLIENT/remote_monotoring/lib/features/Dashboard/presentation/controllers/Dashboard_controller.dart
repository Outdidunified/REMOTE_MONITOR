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
    {'title': 'Devices', 'icon': Icons.devices},
    {'title': 'Monitoring', 'icon': Icons.monitor},
    {'title': 'Alerts', 'icon': Icons.notifications},
    {'title': 'Reports', 'icon': Icons.bar_chart},
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
              style: AppTheme.bodyMedium(Get.context!)
                  .copyWith(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back(); // Close the dialog
              await _sessionController.clearSession(); // Clear session
              Get.offAllNamed('/login'); // Navigate to login page and clear all routes
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
            ),
            child: Text('Logout', style: AppTheme.bodyMedium(Get.context!)),
          ),
        ],
      ),
    );
  }
}