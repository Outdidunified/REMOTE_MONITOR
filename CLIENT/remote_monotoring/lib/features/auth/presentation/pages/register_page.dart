import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remote_monotoring/utils/Layouts/responsive_layout.dart';
import 'package:remote_monotoring/features/auth/presentation/controllers/registerpage_controller.dart';
import 'package:remote_monotoring/utils/theme/app_theme.dart' show AppTheme;
import 'package:remote_monotoring/utils/validators.dart';
import 'package:remote_monotoring/utils/widgets/common_widgets.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
  final controller = Get.put(RegisterPageController());

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
                  Text(
                    'REMOTE MONITORING',
                    style: AppTheme.headingLarge(context),
                  ),
                  SizedBox(height: screenHeight * 0.01),

                  // Subtitle
                  Text(
                    'Register your account',
                    style: AppTheme.bodyLarge(
                      context,
                    ).copyWith(color: AppTheme.textSecondary),
                  ),

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
                            final message = controller.errorMessage.value;
                            if (message == null) return const SizedBox.shrink();

                            final color =
                                controller.isSuccessMessage.value
                                    ? Colors.green
                                    : AppTheme.error;

                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: color),
                              ),
                              child: Text(
                                message,
                                style: AppTheme.bodySmall(
                                  context,
                                ).copyWith(color: color),
                              ),
                            );
                          }),

                          SizedBox(height: ResponsiveLayout.spacing(context)),

                          CommonWidgets.textField(
                            context: context,
                            label: 'Username',
                            hint: 'Enter your Username',
                            controller: controller.usernamecontroller,
                            prefixIcon: Icons.account_circle_outlined,
                            validator: Validators.validateUsername,
                          ),

                          SizedBox(height: ResponsiveLayout.spacing(context)),

                          // Email field
                          CommonWidgets.textField(
                            context: context,
                            label: 'Email',
                            hint: 'Enter your email',
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.email,
                            validator: Validators.validateEmail,
                          ),

                          SizedBox(height: ResponsiveLayout.spacing(context)),

                          // Password field
                          Obx(
                            () => CommonWidgets.textField(
                              context: context,
                              label: 'Password',
                              hint: 'Enter your password',
                              controller: controller.passwordController,
                              obscureText: controller.obscurePassword.value,
                              prefixIcon: Icons.lock,
                              suffixIcon:
                                  controller.obscurePassword.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                              onSuffixIconPressed:
                                  controller.togglePasswordVisibility,
                              validator: Validators.validatePassword,
                            ),
                          ),

                          SizedBox(height: ResponsiveLayout.spacing(context)),
                          // Phone Number field
                          CommonWidgets.textField(
                            context: context,
                            label: 'Phone Number',
                            hint: 'Enter your phone number',
                            controller: controller.phoneController,
                            keyboardType: TextInputType.phone,
                            prefixIcon: Icons.phone,
                            maxLength: 10, // restrict to 10 digits
                            validator: Validators.validatePhone,
                          ),
                          SizedBox(height: ResponsiveLayout.spacing(context)),


                          // Login button
                          Obx(
                            () => CommonWidgets.primaryButton(
                              context: context,
                              text: 'REGISTER',
                              onPressed: controller.register,
                              isLoading: controller.isLoading.value,
                              width: double.infinity,
                            ),
                          ),

                          SizedBox(
                            height: ResponsiveLayout.spacing(context) * 2,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already having an account? ",
                                style: AppTheme.bodySmall(context),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(
                                    '/LoginPage',
                                  ); // or Get.to(() => RegisterPage()) if you're not using named routes
                                },
                                child: Text(
                                  "Sign in",
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
                  Text(
                    'copyrights@remotemonitoring2025',
                    style: AppTheme.caption(context),
                  ),
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
