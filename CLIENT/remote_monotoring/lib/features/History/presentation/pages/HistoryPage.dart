import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remote_monotoring/core/controllers/navigation_controller.dart';
import 'package:remote_monotoring/utils/Layouts/app_layout.dart';
import 'package:remote_monotoring/utils/Layouts/responsive_layout.dart';
import 'package:remote_monotoring/utils/theme/app_theme.dart';
import 'package:remote_monotoring/utils/widgets/common_widgets.dart';

class Historypage extends StatelessWidget {
  Historypage({super.key});

  final NavigationController navigationController =
      Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'History',
      subtitle: 'View historical data and events',
      selectedIndex: 2, // Index for History
      onMenuItemTapped: navigationController.onMenuItemTapped,
      actions: CommonWidgets.secondaryButton(
        context: context,
        text: 'Export Data',
        icon: Icons.download,
        onPressed: () {
          // Export data logic
        },
      ),
      child: _buildHistoryContent(context),
    );
  }

  Widget _buildHistoryContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: AppTheme.primary.withOpacity(0.5),
          ),
          SizedBox(height: ResponsiveLayout.spacing(context)),
          Text(
            'No history data available',
            style: AppTheme.headingMedium(context),
          ),
          SizedBox(height: ResponsiveLayout.spacing(context) / 2),
          Text(
            'Historical data will appear here once your devices start reporting',
            style: AppTheme.bodyMedium(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
