import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:remote_monotoring/features/auth/presentation/controllers/forgotpassword_controller.dart';
import 'package:remote_monotoring/utils/Layouts/responsive_layout.dart';
import 'package:remote_monotoring/utils/theme/app_theme.dart';
import 'package:remote_monotoring/utils/validators.dart';
import 'package:remote_monotoring/utils/widgets/common_widgets.dart';

class ForgotpasswordPage extends StatelessWidget {
  ForgotpasswordPage({super.key});
  final controller = Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: CommonWidgets.circuitBackground(
          context: context,
          child: Center(
            child: SingleChildScrollView(
              padding: ResponsiveLayout.responsiveHorizontalPadding(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonWidgets.logoCircle(context),
                  SizedBox(height: screenHeight * 0.04),
                  Text('REMOTE MONITORING', style: AppTheme.headingLarge(context)),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    'Enter your email id for sending you an otp',
                    style: AppTheme.bodyLarge(context)
                        .copyWith(color: AppTheme.textSecondary),
                  ),
                  SizedBox(height: screenHeight * 0.04),

                  CommonWidgets.card(
                    context: context,
                    width: ResponsiveLayout.widthPercent(
                      context,
                      percent: 0.9,
                      tabletPercent: 0.6,
                      desktopPercent: 0.4,
                      largeDesktopPercent: 0.3,
                    ),
                    child: Form(
                      key: controller.formKey,
                      child: Obx(() {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (controller.errorMessage.isNotEmpty)
                              _messageContainer(context, controller.errorMessage.value, Colors.red),
                            if (controller.resendSuccessMessage.isNotEmpty)
                              _messageContainer(context, controller.resendSuccessMessage.value, Colors.green),
                            if (controller.successMessage.isNotEmpty)
                              _messageContainer(context, controller.successMessage.value, Colors.green),

                            SizedBox(height: ResponsiveLayout.spacing(context)),

                            CommonWidgets.textField(
                              context: context,
                              label: 'Email',
                              hint: 'Enter your email',
                              controller: controller.emailController,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.email,
                              validator: Validators.validateEmail,
                              readOnly: controller.isOtpSent.value,
                              style: controller.isOtpSent.value
                                  ? AppTheme.bodyLarge(context).copyWith(color: Colors.grey)
                                  : null,
                              fillColor: controller.isOtpSent.value ? Colors.grey.shade700 : null,
                            ),

                            SizedBox(height: ResponsiveLayout.spacing(context)),

                            if (controller.isOtpSent.value && !controller.isOtpVerified.value)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      "Enter OTP",
                                      style: AppTheme.bodyLarge(context).copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  CommonWidgets.pinInputField(
                                    context: context,
                                    length: 6,
                                    controller: controller.otpController,
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    validator: Validators.validateOtp,
                                  ),

                                  SizedBox(height: ResponsiveLayout.spacing(context)),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Obx(() {
                                        if (controller.isResendingOtp.value) {
                                          return const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 12),
                                            child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(strokeWidth: 2),
                                            ),
                                          );
                                        }

                                        return TextButton(
                                          onPressed: controller.isResendAvailable.value
                                              ? () => controller.sendOtp(fromResend: true)
                                              : null,
                                          child: Text(
                                            controller.isResendAvailable.value
                                                ? 'Resend OTP'
                                                : 'Resend in ${controller.resendSecondsRemaining.value}s',
                                          ),
                                        );
                                      }),
                                      TextButton(
                                        onPressed: controller.resetToEmailInput,
                                        child: const Text('Change Email'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                            if (controller.isOtpVerified.value)
                              Column(
                                children: [
                                  Obx(() => CommonWidgets.textField(
                                    context: context,
                                    label: 'New Password',
                                    hint: 'Enter new password',
                                    controller: controller.newPasswordController,
                                    obscureText: controller.isNewPasswordVisible.value,
                                    prefixIcon: Icons.lock,
                                    suffixIcon: controller.isNewPasswordVisible.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    onSuffixIconPressed: controller.toggleNewPasswordVisibility,
                                    validator: Validators.validatePassword,
                                  )),

                                  SizedBox(height: ResponsiveLayout.spacing(context)),

                                  Obx(() => CommonWidgets.textField(
                                    context: context,
                                    label: 'Confirm Password',
                                    hint: 'Re-enter new password',
                                    controller: controller.confirmPasswordController,
                                    obscureText: controller.isConfirmPasswordVisible.value,
                                    prefixIcon: Icons.lock_outline,
                                    suffixIcon: controller.isConfirmPasswordVisible.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    onSuffixIconPressed: controller.toggleConfirmPasswordVisibility,
                                    validator: (val) {
                                      if (val == null || val.isEmpty) return 'Please confirm password';
                                      if (val != controller.newPasswordController.text) return 'Passwords do not match';
                                      return null;
                                    },
                                  )),
                                ],
                              ),



                            SizedBox(height: ResponsiveLayout.spacing(context)),

                            CommonWidgets.primaryButton(
                              context: context,
                              text: controller.isOtpVerified.value
                                  ? 'UPDATE PASSWORD'
                                  : controller.isOtpSent.value
                                  ? 'VERIFY OTP'
                                  : 'GET OTP',
                              onPressed: () async {
                                if (controller.formKey.currentState!.validate()) {
                                  if (!controller.isOtpSent.value) {
                                    await controller.sendOtp();
                                  } else if (!controller.isOtpVerified.value) {
                                    await controller.verifyOtp();
                                  } else {
                                    await controller.updatePassword();
                                  }
                                }
                              },
                              isLoading: controller.isLoading.value,
                              width: double.infinity,
                            ),

                            SizedBox(height: ResponsiveLayout.spacing(context) * 2),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () => Get.toNamed('/login'),
                                  child: Text(
                                    "<< Go back to LoginPage",
                                    style: AppTheme.bodySmall(context).copyWith(
                                      color: AppTheme.accentColor,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                    ),

                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Text('copyrights@remotemonitoring2025', style: AppTheme.caption(context)),
                  Text('version: v1.0.0', style: AppTheme.caption(context)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _messageContainer(BuildContext context, String msg, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Text(
        msg,
        style: AppTheme.bodySmall(context).copyWith(color: color),
      ),
    );
  }
}
