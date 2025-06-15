import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remote_monotoring/core/controllers/navigation_controller.dart';
import 'package:remote_monotoring/utils/Layouts/app_layout.dart';
import 'package:remote_monotoring/utils/Layouts/responsive_layout.dart';
import 'package:remote_monotoring/utils/theme/app_theme.dart';
import 'package:remote_monotoring/utils/widgets/common_widgets.dart';

class Analyticspage extends StatelessWidget {
  Analyticspage({super.key});

  final NavigationController navigationController =
      Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Analytics',
      subtitle: 'Insights and data visualization',
      selectedIndex: 3, // Index for Analytics
      onMenuItemTapped: navigationController.onMenuItemTapped,
      actions: Row(
        children: [
          CommonWidgets.secondaryButton(
            context: context,
            text: 'Filter',
            icon: Icons.filter_list,
            onPressed: () {
              // Filter logic
            },
          ),
          SizedBox(width: ResponsiveLayout.spacing(context)),
          CommonWidgets.primaryButton(
            context: context,
            text: 'Generate Report',
            icon: Icons.assessment,
            onPressed: () {
              // Generate report logic
            },
          ),
        ],
      ),
      child: _buildAnalyticsContent(context),
    );
  }

  Widget _buildAnalyticsContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart,
            size: 80,
            color: AppTheme.primary.withOpacity(0.5),
          ),
          SizedBox(height: ResponsiveLayout.spacing(context)),
          Text('Analytics Dashboard', style: AppTheme.headingMedium(context)),
          SizedBox(height: ResponsiveLayout.spacing(context) / 2),
          Text(
            'Data visualization and insights will appear here',
            style: AppTheme.bodyMedium(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
