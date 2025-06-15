import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remote_monotoring/core/controllers/navigation_controller.dart';
import 'package:remote_monotoring/core/controllers/session_controller.dart';
import 'package:remote_monotoring/features/Dashboard/presentation/controllers/Dashboard_controller.dart';
import 'package:remote_monotoring/utils/Layouts/app_layout.dart';
import 'package:remote_monotoring/utils/Layouts/responsive_layout.dart';
import 'package:remote_monotoring/utils/theme/app_theme.dart';
import 'package:remote_monotoring/utils/widgets/common_widgets.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  final DashboardController controller = Get.put(DashboardController());
  final NavigationController navigationController =
      Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Dashboard',
      subtitle: 'Overview of your system monitoring',
      selectedIndex: navigationController.selectedIndex.value,
      onMenuItemTapped: navigationController.onMenuItemTapped,
      actions: Row(
        children: [
          CommonWidgets.secondaryButton(
            context: context,
            text: 'Refresh',
            icon: Icons.refresh,
            onPressed: () {},
          ),
          SizedBox(width: ResponsiveLayout.spacing(context)),
          CommonWidgets.primaryButton(
            context: context,
            text: 'Add Device',
            icon: Icons.add,
            onPressed: () {},
          ),
        ],
      ),
      child: _buildDashboardContent(context),
    );
  }

  Widget _buildDesktopSidebar(BuildContext context) {
    final sessionController = Get.find<SessionController>();

    return Container(
      width: ResponsiveLayout.value<double>(
        context: context,
        mobile: 0,
        tablet: 240,
        desktop: 280,
      ),
      color: AppTheme.backgroundDark,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppTheme.accentRadialGradient,
                    ),
                    child: const Icon(
                      Icons.desktop_windows,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'REMOTE MONITORING',
                    style: AppTheme.headingSmall(context),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.backgroundMedium,
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.textMuted.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.primary,
                  child: Text(
                    sessionController.username.value.isNotEmpty
                        ? sessionController.username.value[0].toUpperCase()
                        : 'U',
                    style: AppTheme.bodyMedium(
                      context,
                    ).copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sessionController.username.value.isNotEmpty
                            ? sessionController.username.value
                            : 'User',
                        style: AppTheme.bodyMedium(
                          context,
                        ).copyWith(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        sessionController.emailId.value.isNotEmpty
                            ? sessionController.emailId.value
                            : 'user@example.com',
                        style: AppTheme.caption(context),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: controller.logout,
                  icon: const Icon(Icons.logout, color: AppTheme.error),
                  tooltip: 'Logout',
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: controller.menuItems.length,
              itemBuilder: (context, index) {
                final item = controller.menuItems[index];
                final isSelected = controller.selectedIndex.value == index;

                return CommonWidgets.drawerItem(
                  context: context,
                  title: item['title'],
                  icon: item['icon'],
                  isSelected: isSelected,
                  onTap: () => controller.onMenuItemTapped(index),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'v1.0.0',
              style: AppTheme.caption(context),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileDrawer(BuildContext context) {
    final sessionController = Get.find<SessionController>();

    return CommonWidgets.drawer(
      context: context,
      title: 'REMOTE MONITORING',
      header: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: Center(
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.accentRadialGradient,
                ),
                child: const Icon(
                  Icons.desktop_windows,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text('REMOTE MONITORING', style: AppTheme.headingSmall(context)),
            ],
          ),
        ),
      ),
      items:
          controller.menuItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = controller.selectedIndex.value == index;

            return CommonWidgets.drawerItem(
              context: context,
              title: item['title'],
              icon: item['icon'],
              isSelected: isSelected,
              onTap: () {
                controller.onMenuItemTapped(index);
                Navigator.pop(context);
              },
            );
          }).toList(),
      footer: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CommonWidgets.divider(context),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.primary,
                child: Text(
                  sessionController.username.value.isNotEmpty
                      ? sessionController.username.value[0].toUpperCase()
                      : 'U',
                  style: AppTheme.bodyMedium(
                    context,
                  ).copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                sessionController.username.value.isNotEmpty
                    ? sessionController.username.value
                    : 'User',
                style: AppTheme.bodyMedium(context),
              ),
              subtitle: Text(
                sessionController.emailId.value.isNotEmpty
                    ? sessionController.emailId.value
                    : 'user@example.com',
                style: AppTheme.caption(context),
              ),
              trailing: IconButton(
                onPressed: controller.logout,
                icon: const Icon(Icons.logout, color: AppTheme.error),
              ),
            ),
            const SizedBox(height: 8),
            Text('v1.0.0', style: AppTheme.caption(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusCards(context),
        SizedBox(height: ResponsiveLayout.spacing(context) * 2),
        Expanded(child: _buildChartsAndTables(context)),
      ],
    );
  }

  Widget _buildStatusCards(BuildContext context) {
    return GridView.count(
      crossAxisCount: ResponsiveLayout.value<int>(
        context: context,
        mobile: 1,
        tablet: 2,
        desktop: 4,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: ResponsiveLayout.spacing(context),
      mainAxisSpacing: ResponsiveLayout.spacing(context),
      childAspectRatio: ResponsiveLayout.value<double>(
        context: context,
        mobile: 2.5,
        tablet: 2.2,
        desktop: 1.8,
      ),
      children: [
        _buildStatusCard(
          context: context,
          title: 'Total Devices',
          value: '24',
          icon: Icons.devices,
          color: AppTheme.primary,
          trend: '+3',
          isUp: true,
        ),
        _buildStatusCard(
          context: context,
          title: 'Online',
          value: '21',
          icon: Icons.check_circle,
          color: AppTheme.success,
          trend: '87.5%',
          isUp: true,
        ),
        _buildStatusCard(
          context: context,
          title: 'Alerts',
          value: '7',
          icon: Icons.warning,
          color: AppTheme.warning,
          trend: '+2',
          isUp: false,
        ),
        _buildStatusCard(
          context: context,
          title: 'Critical Issues',
          value: '2',
          icon: Icons.error,
          color: AppTheme.error,
          trend: '-1',
          isUp: true,
        ),
      ],
    );
  }

  Widget _buildStatusCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String trend,
    required bool isUp,
  }) {
    return CommonWidgets.card(
      context: context,
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          SizedBox(width: ResponsiveLayout.spacing(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: AppTheme.bodySmall(context)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(value, style: AppTheme.headingMedium(context)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: (isUp ? AppTheme.success : AppTheme.error)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isUp ? Icons.arrow_upward : Icons.arrow_downward,
                            color: isUp ? AppTheme.success : AppTheme.error,
                            size: 12,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            trend,
                            style: AppTheme.caption(context).copyWith(
                              color: isUp ? AppTheme.success : AppTheme.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsAndTables(BuildContext context) {
    return ResponsiveLayout.isDesktop(context) ||
            ResponsiveLayout.isLargeDesktop(context)
        ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: CommonWidgets.card(
                context: context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidgets.sectionHeader(
                      context: context,
                      title: 'System Performance',
                      subtitle: 'Last 24 hours',
                      trailing: DropdownButton<String>(
                        value: 'Today',
                        items:
                            [
                              'Today',
                              'Yesterday',
                              'Last Week',
                              'Last Month',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: AppTheme.bodySmall(context),
                                ),
                              );
                            }).toList(),
                        onChanged: (_) {},
                        style: AppTheme.bodySmall(context),
                        dropdownColor: AppTheme.backgroundLight,
                        underline: Container(),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundLight.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.bar_chart,
                                size: 48,
                                color: AppTheme.accentColor.withOpacity(0.7),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Performance Chart',
                                style: AppTheme.bodyMedium(context),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'CPU, Memory, and Network usage over time',
                                style: AppTheme.caption(context),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: ResponsiveLayout.spacing(context)),
            Expanded(
              child: CommonWidgets.card(
                context: context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidgets.sectionHeader(
                      context: context,
                      title: 'Recent Alerts',
                      subtitle: 'Last 5 alerts',
                      trailing: TextButton(
                        onPressed: () {},
                        child: const Text('View All'),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: 5,
                        separatorBuilder:
                            (context, index) =>
                                const Divider(color: AppTheme.backgroundLight),
                        itemBuilder: (context, index) {
                          final alertTypes = [
                            {
                              'icon': Icons.warning,
                              'color': AppTheme.warning,
                              'text': 'Warning',
                            },
                            {
                              'icon': Icons.error,
                              'color': AppTheme.error,
                              'text': 'Critical',
                            },
                            {
                              'icon': Icons.info,
                              'color': AppTheme.info,
                              'text': 'Info',
                            },
                          ];

                          final alertType =
                              alertTypes[index % alertTypes.length];
                          final color = alertType['color'] as Color;

                          return ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                alertType['icon'] as IconData,
                                color: color,
                              ),
                            ),
                            title: Text(
                              'Device ${index + 1} - ${alertType['text']}',
                              style: AppTheme.bodyMedium(context),
                            ),
                            subtitle: Text(
                              'Alert triggered at ${DateTime.now().subtract(Duration(minutes: index * 15)).hour}:${DateTime.now().subtract(Duration(minutes: index * 15)).minute.toString().padLeft(2, '0')}',
                              style: AppTheme.caption(context),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () {},
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
        : Column(
          children: [
            Expanded(
              child: CommonWidgets.card(
                context: context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidgets.sectionHeader(
                      context: context,
                      title: 'System Performance',
                      subtitle: 'Last 24 hours',
                      trailing: DropdownButton<String>(
                        value: 'Today',
                        items:
                            [
                              'Today',
                              'Yesterday',
                              'Last Week',
                              'Last Month',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: AppTheme.bodySmall(context),
                                ),
                              );
                            }).toList(),
                        onChanged: (_) {},
                        style: AppTheme.bodySmall(context),
                        dropdownColor: AppTheme.backgroundLight,
                        underline: Container(),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundLight.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.bar_chart,
                                size: 48,
                                color: AppTheme.accentColor.withOpacity(0.7),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Performance Chart',
                                style: AppTheme.bodyMedium(context),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'CPU, Memory, and Network usage over time',
                                style: AppTheme.caption(context),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: ResponsiveLayout.spacing(context)),
            Expanded(
              child: CommonWidgets.card(
                context: context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidgets.sectionHeader(
                      context: context,
                      title: 'Recent Alerts',
                      subtitle: 'Last 5 alerts',
                      trailing: TextButton(
                        onPressed: () {},
                        child: const Text('View All'),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: 5,
                        separatorBuilder:
                            (context, index) =>
                                const Divider(color: AppTheme.backgroundLight),
                        itemBuilder: (context, index) {
                          final alertTypes = [
                            {
                              'icon': Icons.warning,
                              'color': AppTheme.warning,
                              'text': 'Warning',
                            },
                            {
                              'icon': Icons.error,
                              'color': AppTheme.error,
                              'text': 'Critical',
                            },
                            {
                              'icon': Icons.info,
                              'color': AppTheme.info,
                              'text': 'Info',
                            },
                          ];

                          final alertType =
                              alertTypes[index % alertTypes.length];
                          final color = alertType['color'] as Color;

                          return ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                alertType['icon'] as IconData,
                                color: color,
                              ),
                            ),
                            title: Text(
                              'Device ${index + 1} - ${alertType['text']}',
                              style: AppTheme.bodyMedium(context),
                            ),
                            subtitle: Text(
                              'Alert triggered at ${DateTime.now().subtract(Duration(minutes: index * 15)).hour}:${DateTime.now().subtract(Duration(minutes: index * 15)).minute.toString().padLeft(2, '0')}',
                              style: AppTheme.caption(context),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () {},
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
  }
}
