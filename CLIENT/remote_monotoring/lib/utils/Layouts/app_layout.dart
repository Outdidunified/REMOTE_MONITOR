import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remote_monotoring/core/controllers/session_controller.dart';
import 'package:remote_monotoring/utils/Layouts/responsive_layout.dart';
import 'package:remote_monotoring/utils/theme/app_theme.dart';
import 'package:remote_monotoring/utils/widgets/common_widgets.dart';

/// A shared layout component that provides a consistent UI structure
/// with sidebar navigation for all main pages
class AppLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final String subtitle;
  final Widget? actions;
  final int selectedIndex;
  final Function(int) onMenuItemTapped;

  // Menu items for the sidebar/drawer
  final List<Map<String, dynamic>> menuItems = [
    {'title': 'Dashboard', 'icon': Icons.dashboard},
    {'title': 'Manage Devices', 'icon': Icons.devices},
    {'title': 'History', 'icon': Icons.history},
    {'title': 'Analytics', 'icon': Icons.bar_chart},
    {'title': 'Settings', 'icon': Icons.settings},
  ];

  AppLayout({
    super.key,
    required this.child,
    required this.title,
    this.subtitle = 'Overview of your system monitoring',
    this.actions,
    required this.selectedIndex,
    required this.onMenuItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          if (!ResponsiveLayout.isMobile(context))
            _buildDesktopSidebar(context),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppTheme.backgroundDark, AppTheme.backgroundMedium],
                ),
              ),
              child: CommonWidgets.circuitBackground(
                context: context,
                opacity: 0.05,
                child: Column(
                  children: [
                    if (ResponsiveLayout.isMobile(context))
                      AppBar(
                        title: const Text('REMOTE MONITORING'),
                        backgroundColor: AppTheme.primaryDark,
                        leading: IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                        actions: [
                          IconButton(
                            onPressed: _logout,
                            icon: const Icon(Icons.logout),
                          ),
                        ],
                      ),
                    Expanded(
                      child: Padding(
                        padding: ResponsiveLayout.responsivePadding(context),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonWidgets.sectionHeader(
                              context: context,
                              title: title,
                              subtitle: subtitle,
                              trailing: actions,
                            ),
                            SizedBox(height: ResponsiveLayout.spacing(context)),
                            Expanded(child: child),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      drawer:
          ResponsiveLayout.isMobile(context)
              ? _buildMobileDrawer(context)
              : null,
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
                  onPressed: _logout,
                  icon: const Icon(Icons.logout, color: AppTheme.error),
                  tooltip: 'Logout',
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                final isSelected = selectedIndex == index;

                return CommonWidgets.drawerItem(
                  context: context,
                  title: item['title'],
                  icon: item['icon'],
                  isSelected: isSelected,
                  onTap: () => onMenuItemTapped(index),
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
          menuItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = selectedIndex == index;

            return CommonWidgets.drawerItem(
              context: context,
              title: item['title'],
              icon: item['icon'],
              isSelected: isSelected,
              onTap: () {
                onMenuItemTapped(index);
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
                onPressed: _logout,
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

  void _logout() {
    final sessionController = Get.find<SessionController>();

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
              await sessionController.clearSession(); // Clear session
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
