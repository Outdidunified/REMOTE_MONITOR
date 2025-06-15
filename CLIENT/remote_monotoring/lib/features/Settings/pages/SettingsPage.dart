import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remote_monotoring/core/controllers/navigation_controller.dart';
import 'package:remote_monotoring/core/controllers/session_controller.dart';
import 'package:remote_monotoring/utils/Layouts/app_layout.dart';
import 'package:remote_monotoring/utils/Layouts/responsive_layout.dart';
import 'package:remote_monotoring/utils/theme/app_theme.dart';
import 'package:remote_monotoring/utils/widgets/common_widgets.dart';
import 'package:remote_monotoring/utils/widgets/custom_alert.dart';

class Settingspage extends StatelessWidget {
  Settingspage({super.key});

  final NavigationController navigationController =
      Get.find<NavigationController>();
  final SessionController sessionController = Get.find<SessionController>();

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Settings',
      subtitle: 'Configure your account and application settings',
      selectedIndex: 4, // Index for Settings
      onMenuItemTapped: navigationController.onMenuItemTapped,
      actions: CommonWidgets.primaryButton(
        context: context,
        text: 'Save Changes',
        icon: Icons.save,
        onPressed: () {
          // Save settings logic
          CustomAlert.success(
            message: 'Settings saved successfully!',
            onConfirm: () {},
          );
        },
      ),
      child: _buildSettingsContent(context),
    );
  }

  Widget _buildSettingsContent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, 'Account Settings'),
            _buildSettingsCard(
              context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileInfo(context),
                  SizedBox(height: ResponsiveLayout.spacing(context)),
                  CommonWidgets.divider(context),
                  SizedBox(height: ResponsiveLayout.spacing(context)),
                  _buildAccountActions(context),
                ],
              ),
            ),
            SizedBox(height: ResponsiveLayout.spacing(context) * 2),
            _buildSectionHeader(context, 'Application Settings'),
            _buildSettingsCard(
              context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSettingItem(
                    context,
                    title: 'Notifications',
                    subtitle: 'Configure notification preferences',
                    icon: Icons.notifications,
                    onTap: () {
                      // Navigate to notifications settings
                    },
                  ),
                  CommonWidgets.divider(context),
                  _buildSettingItem(
                    context,
                    title: 'Data Refresh Interval',
                    subtitle: 'Set how often data is refreshed',
                    icon: Icons.refresh,
                    onTap: () {
                      // Open refresh interval settings
                    },
                  ),
                  CommonWidgets.divider(context),
                  _buildSettingItem(
                    context,
                    title: 'Theme Settings',
                    subtitle: 'Customize application appearance',
                    icon: Icons.palette,
                    onTap: () {
                      // Open theme settings
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveLayout.spacing(context) * 2),
            _buildSectionHeader(context, 'System Information'),
            _buildSettingsCard(
              context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoItem(context, 'Version', 'v1.0.0'),
                  SizedBox(height: ResponsiveLayout.spacing(context) / 2),
                  _buildInfoItem(context, 'Build Number', '2023.1.1'),
                  SizedBox(height: ResponsiveLayout.spacing(context) / 2),
                  _buildInfoItem(context, 'Server Status', 'Connected'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(title, style: AppTheme.headingSmall(context)),
    );
  }

  Widget _buildSettingsCard(BuildContext context, {required Widget child}) {
    return CommonWidgets.card(context: context, child: child);
  }

  Widget _buildProfileInfo(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppTheme.primary,
          child: Text(
            sessionController.username.value.isNotEmpty
                ? sessionController.username.value[0].toUpperCase()
                : 'U',
            style: AppTheme.headingMedium(context),
          ),
        ),
        SizedBox(width: ResponsiveLayout.spacing(context)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sessionController.username.value,
                style: AppTheme.headingSmall(context),
              ),
              SizedBox(height: 4),
              Text(
                sessionController.emailId.value,
                style: AppTheme.bodyMedium(context),
              ),
              SizedBox(height: 4),
              Text(
                'Role: ${sessionController.roleName.value}',
                style: AppTheme.bodySmall(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccountActions(BuildContext context) {
    return Wrap(
      spacing: ResponsiveLayout.spacing(context),
      runSpacing: ResponsiveLayout.spacing(context) / 2,
      children: [
        CommonWidgets.secondaryButton(
          context: context,
          text: 'Edit Profile',
          icon: Icons.edit,
          onPressed: () {
            // Edit profile logic
          },
        ),
        CommonWidgets.secondaryButton(
          context: context,
          text: 'Change Password',
          icon: Icons.lock,
          onPressed: () {
            // Change password logic
          },
        ),
        CommonWidgets.secondaryButton(
          context: context,
          text: 'Logout',
          icon: Icons.logout,
          onPressed: () {
            CustomAlert.confirm(
              title: 'Logout',
              message: 'Are you sure you want to logout?',
              onConfirm: () async {
                await sessionController.clearSession();
                Get.offAllNamed('/login');
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.accentColor),
      title: Text(
        title,
        style: AppTheme.bodyMedium(
          context,
        ).copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle, style: AppTheme.bodySmall(context)),
      trailing: const Icon(Icons.chevron_right, color: AppTheme.textMuted),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: AppTheme.bodyMedium(
            context,
          ).copyWith(fontWeight: FontWeight.bold),
        ),
        Text(value, style: AppTheme.bodyMedium(context)),
      ],
    );
  }
}
