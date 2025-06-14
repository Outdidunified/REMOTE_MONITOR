import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remote_monotoring/utils/Layouts/responsive_layout.dart';
import 'package:remote_monotoring/features/auth/presentation/controllers/forgotpassword_controller.dart';
import 'package:remote_monotoring/utils/theme/app_theme.dart';
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
                  // Logo
                  CommonWidgets.logoCircle(context),

                  SizedBox(height: screenHeight * 0.04),

                  // Title
                  Text('REMOTE MONITORING', style: AppTheme.headingLarge(context)),
                  SizedBox(height: screenHeight * 0.01),

                  // Subtitle
                  Text('Enter your email id for sending you an otp ',
                      style: AppTheme.bodyLarge(context)
                          .copyWith(color: AppTheme.textSecondary)),

                  SizedBox(height: screenHeight * 0.04),

                  // Login form card
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Error message
                          Obx(() {
                            if (controller.errorMessage.value == null) {
                              return const SizedBox.shrink();
                            }
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppTheme.error),
                              ),
                              child: Text(
                                controller.errorMessage.value!,
                                style: AppTheme.bodySmall(context)
                                    .copyWith(color: AppTheme.error),
                              ),
                            );
                          }),
                          SizedBox(height: ResponsiveLayout.spacing(context)),

                          // Email field
                          CommonWidgets.textField(
                            context: context,
                            label: 'Email',
                            hint: 'Enter your email',
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.email,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: ResponsiveLayout.spacing(context)),



                          // Remember me & Forgot Password


                          SizedBox(
                              height: ResponsiveLayout.spacing(context) * 1),

                          // Login button
                          Obx(() => CommonWidgets.primaryButton(
                            context: context,
                            text: 'GET OTP',
                            onPressed: controller.sendOtp,
                            isLoading: controller.isLoading.value,
                            width: double.infinity,
                          )),

                          SizedBox(
                              height: ResponsiveLayout.spacing(context) * 2),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              GestureDetector(
                                onTap: () {
                                  Get.toNamed('/LoginPage'); // ✅ Just navigate using the route name
                                },

                                child: Text(
                                  "<< Go back to LoginPage ",
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
                      ),
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
}
