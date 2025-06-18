import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remote_monotoring/core/controllers/navigation_controller.dart';
import 'package:remote_monotoring/core/controllers/session_controller.dart';
import 'package:remote_monotoring/features/Settings/presentation/controllers/settings_controllers.dart';
import 'package:remote_monotoring/utils/Layouts/app_layout.dart';
import 'package:remote_monotoring/utils/Layouts/responsive_layout.dart';
import 'package:remote_monotoring/utils/theme/app_theme.dart';
import 'package:remote_monotoring/utils/validators.dart';
import 'package:remote_monotoring/utils/widgets/common_widgets.dart';
import 'package:remote_monotoring/utils/widgets/custom_alert.dart';

class Settingspage extends StatelessWidget {
  Settingspage({super.key});

  final SettingsController settingsController = Get.put(SettingsController());
  final NavigationController navigationController = Get.find<NavigationController>();
  final SessionController sessionController = Get.find<SessionController>();

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Settings',
      subtitle: 'Configure your account and application settings',
      selectedIndex: 4,
      onMenuItemTapped: navigationController.onMenuItemTapped,
      actions: Obx(() {
        final isEditing = settingsController.isEditing.value;
        final isDirty = settingsController.isDirty.value;

        void onSavePressed() {
          if (!settingsController.formKey.currentState!.validate()) {
            return; // ❌ Don't proceed if validation fails
          }

          final name = settingsController.usernameController.text.trim();
          final phoneText = settingsController.phoneController.text.trim();
          final password = settingsController.passwordController.text.trim();

          final phoneInt = int.tryParse(phoneText);
          if (phoneInt == null) {
            CustomAlert.error(message: 'Phone number must be numeric.');
            return;
          }

          settingsController.updateProfile(
            name: name,
            phone: phoneInt,
            password: password.isNotEmpty ? password : null,
          ).then((_) {
            if (settingsController.errorMessage.isEmpty) {
              CustomAlert.success(
                message: 'Profile updated successfully!',
                onConfirm: () {},
              );
              settingsController.isEditing.value = false;
              settingsController.isDirty.value = false;
              settingsController.populateOriginalData();
            } else {
              CustomAlert.error(
                message: settingsController.errorMessage.value,
              );
            }
          });
        }

        return CommonWidgets.primaryButton(
          context: context,
          text: 'Save Changes',
          icon: Icons.save,
          onPressed: (isEditing && isDirty) ? onSavePressed : null, // ✅ Always non-null
        );
      }),
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

  Widget _buildSectionHeader(BuildContext context, String title) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Text(title, style: AppTheme.headingSmall(context)),
      );

  Widget _buildSettingsCard(BuildContext context, {required Widget child}) =>
      CommonWidgets.card(context: context, child: child);

  Widget _buildProfileInfo(BuildContext context) {
    return Obx(() {
      final profile = settingsController.userProfile.value?.data;

      if (settingsController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (profile == null) {
        return Center(child: Text('No profile data available.', style: AppTheme.bodyMedium(context)));
      }

      return Form( // ✅ Added Form
        key: settingsController.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppTheme.primary,
                  child: Text(
                    (profile.name?.isNotEmpty ?? false) ? profile.name![0].toUpperCase() : 'U',
                    style: AppTheme.headingMedium(context),
                  ),
                ),
                SizedBox(width: ResponsiveLayout.spacing(context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profile.name ?? '', style: AppTheme.headingSmall(context)),
                      SizedBox(height: 4),
                      Text(profile.email ?? '', style: AppTheme.bodyMedium(context)),
                      SizedBox(height: 4),
                      Text('Role: ${profile.roleName ?? 'N/A'}', style: AppTheme.bodySmall(context)),
                    ],
                  ),
                ),
              ],
            ),
            if (settingsController.isEditing.value) ...[
              SizedBox(height: ResponsiveLayout.spacing(context)),
              CommonWidgets.textField(
                context: context,
                label: 'Username',
                hint: 'Enter new username',
                controller: settingsController.usernameController,
                validator: Validators.validateUsername,
              ),
              SizedBox(height: ResponsiveLayout.spacing(context) / 2),
              CommonWidgets.textField(
                context: context,
                label: 'Password',
                hint: 'Enter new password',
                controller: settingsController.passwordController,
                validator: Validators.validatePassword,
              ),
              SizedBox(height: ResponsiveLayout.spacing(context) / 2),
              CommonWidgets.textField(
                context: context,
                label: 'Phone Number',
                hint: 'Enter phone number',
                keyboardType: TextInputType.phone,
                controller: settingsController.phoneController,
                validator: Validators.validatePhone,
              ),
            ],
          ],
        ),
      );
    });
  }


  Widget _buildAccountActions(BuildContext context) {
    return Obx(() => Wrap(
      spacing: ResponsiveLayout.spacing(context),
      runSpacing: ResponsiveLayout.spacing(context) / 2,
      children: [
        CommonWidgets.secondaryButton(
          context: context,
          text: settingsController.isEditing.value ? 'Cancel Edit' : 'Edit Profile',
          icon: settingsController.isEditing.value ? Icons.close : Icons.edit,
          onPressed: () {
            if (!settingsController.isEditing.value) {
              final profile = settingsController.userProfile.value?.data;
              settingsController.usernameController.text = profile?.name ?? '';
              settingsController.phoneController.text = profile?.phone ?? '';
              settingsController.passwordController.text = profile?.password ?? '';
              settingsController.isDirty.value = false;
            }
            settingsController.isEditing.toggle(); // ✅ Toggle editing
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
    ));
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Row(
      children: [
        Text('$label: ', style: AppTheme.bodyMedium(context).copyWith(fontWeight: FontWeight.bold)),
        Text(value, style: AppTheme.bodyMedium(context)),
      ],
    );
  }
}
