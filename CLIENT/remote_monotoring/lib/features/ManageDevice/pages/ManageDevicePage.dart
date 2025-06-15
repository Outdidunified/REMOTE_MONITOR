import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remote_monotoring/core/controllers/navigation_controller.dart';
import 'package:remote_monotoring/utils/Layouts/app_layout.dart';
import 'package:remote_monotoring/utils/Layouts/responsive_layout.dart';
import 'package:remote_monotoring/utils/theme/app_theme.dart';
import 'package:remote_monotoring/utils/widgets/common_widgets.dart';

class Managedevicepage extends StatelessWidget {
  Managedevicepage({super.key});

  final NavigationController navigationController =
      Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Manage Devices',
      subtitle: 'Add, edit, and monitor your devices',
      selectedIndex: 1, // Index for Manage Devices
      onMenuItemTapped: navigationController.onMenuItemTapped,
      actions: CommonWidgets.primaryButton(
        context: context,
        text: 'Add New Device',
        icon: Icons.add,
        onPressed: () {
          // Add device logic
        },
      ),
      child: _buildManageDevicesContent(context),
    );
  }

  Widget _buildManageDevicesContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.devices,
            size: 80,
            color: AppTheme.primary.withOpacity(0.5),
          ),
          SizedBox(height: ResponsiveLayout.spacing(context)),
          Text('No devices added yet', style: AppTheme.headingMedium(context)),
          SizedBox(height: ResponsiveLayout.spacing(context) / 2),
          Text(
            'Add your first device to start monitoring',
            style: AppTheme.bodyMedium(context),
          ),
          SizedBox(height: ResponsiveLayout.spacing(context) * 2),
          CommonWidgets.primaryButton(
            context: context,
            text: 'Add Device',
            icon: Icons.add,
            onPressed: () {
              // Add device logic
            },
          ),
        ],
      ),
    );
  }
}
