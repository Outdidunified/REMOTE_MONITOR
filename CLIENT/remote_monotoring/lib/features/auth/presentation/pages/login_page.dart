import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remote_monotoring/utils/Layouts/responsive_layout.dart';
import 'package:remote_monotoring/features/auth/presentation/controllers/login_page_controllers.dart';
import 'package:remote_monotoring/utils/theme/app_theme.dart';
import 'package:remote_monotoring/utils/validators.dart';
import 'package:remote_monotoring/utils/widgets/common_widgets.dart';
import 'package:remote_monotoring/utils/widgets/delayed_animation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late final LoginPageController controller;
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize controller
    controller = Get.put(LoginPageController());

    // Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: CommonWidgets.circuitBackground(
          context: context,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(scale: _scaleAnimation, child: child),
              );
            },
            child: Center(
              child: SingleChildScrollView(
                padding: ResponsiveLayout.responsiveHorizontalPadding(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo with animation
                    TweenAnimationBuilder<double>(
                      duration: const Duration(seconds: 1),
                      tween: Tween<double>(begin: 0, end: 1),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(scale: value, child: child);
                      },
                      child: CommonWidgets.logoCircle(context),
                    ),

                    SizedBox(
                      height: ResponsiveLayout.heightPercent(
                        context,
                        percent: 0.04,
                      ),
                    ),

                    // Title with animation
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 800),
                      tween: Tween<double>(begin: 0, end: 1),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        'REMOTE MONITORING',
                        style: AppTheme.headingLarge(context),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(
                      height: ResponsiveLayout.heightPercent(
                        context,
                        percent: 0.01,
                      ),
                    ),

                    // Subtitle with animation
                    DelayedAnimation(
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        'Login to your account',
                        style: AppTheme.bodyLarge(
                          context,
                        ).copyWith(color: AppTheme.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(
                      height: ResponsiveLayout.heightPercent(
                        context,
                        percent: 0.04,
                      ),
                    ),

                    // Login form card with animation
                    DelayedAnimation(
                      delay: const Duration(milliseconds: 400),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 30 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Obx(
                        () => AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: controller.formOpacity.value,
                          child: CommonWidgets.card(
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
                                  // Error message with animation
                                  Obx(() {
                                    final msg = controller.errorMessage.value;
                                    if (msg == null) return const SizedBox.shrink();

                                    final color = controller.isSuccess.value
                                        ? Colors.green
                                        : AppTheme.error;

                                    return AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      padding: const EdgeInsets.all(12),
                                      margin: const EdgeInsets.only(bottom: 16),
                                      decoration: BoxDecoration(
                                        color: color.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: color),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            controller.isSuccess.value
                                                ? Icons.check_circle_outline
                                                : Icons.error_outline,
                                            color: color,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              msg,
                                              style: AppTheme.bodySmall(context).copyWith(color: color),
                                            ),
                                          ),
                                          if (controller.isSuccess.value)
                                            const SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  }),

                                  SizedBox(
                                    height: ResponsiveLayout.spacing(context),
                                  ),

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

                                  SizedBox(
                                    height: ResponsiveLayout.spacing(context),
                                  ),

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

                                  SizedBox(
                                    height: ResponsiveLayout.spacing(context),
                                  ),

                                  // Remember me & Forgot Password
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildRememberMe(context),
                                      _buildForgotPassword(context),
                                    ],
                                  );
                                },
                              ),


                              SizedBox(
                                    height:
                                        ResponsiveLayout.spacing(context) * 1.5,
                                  ),

                                  // Login button with animation
                                  Obx(
                                    () => CommonWidgets.primaryButton(
                                      context: context,
                                      text: 'LOGIN',
                                      onPressed: controller.login,
                                      isLoading: controller.isLoading.value,
                                      width: double.infinity,
                                    ),
                                  ),

                                  SizedBox(
                                    height:
                                        ResponsiveLayout.spacing(context) * 2,
                                  ),

                                  // Sign up link
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Don't have an account? ",
                                        style: AppTheme.bodySmall(context),
                                      ),
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.toNamed('/register');
                                          },
                                          child: Text(
                                            "Sign up",
                                            style: AppTheme.bodySmall(
                                              context,
                                            ).copyWith(
                                              color: AppTheme.accentColor,
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: ResponsiveLayout.heightPercent(
                        context,
                        percent: 0.04,
                      ),
                    ),

                    // Footer with animation
                    DelayedAnimation(
                      delay: const Duration(milliseconds: 600),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(opacity: value, child: child);
                      },
                      child: Column(
                        children: [
                          Text(
                            'copyrights@remotemonitoring2025',
                            style: AppTheme.caption(context),
                          ),
                          Text(
                            'version: v1.0.0',
                            style: AppTheme.caption(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build the remember me checkbox
  // In LoginPage.dart
  Widget _buildRememberMe(BuildContext context) {
    return Obx(() {
      final hasError = controller.errorMessage.value?.contains('remember') ?? false;

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: hasError
                ? BoxDecoration(
              border: Border.all(color: AppTheme.error),
              borderRadius: BorderRadius.circular(4),
            )
                : null,
            child: SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: controller.rememberMe.value,
                onChanged: (value) {
                  controller.rememberMe.value = value ?? false;
                  // Clear error when user interacts
                  if (controller.errorMessage.value?.contains('remember') ?? false) {
                    controller.errorMessage.value = null;
                  }
                },
                activeColor: AppTheme.accentColor,
                fillColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return AppTheme.accentColor;
                    }
                    return Colors.transparent;
                  },
                ),
              ),
            ),
          ),
          SizedBox(width: ResponsiveLayout.spacing(context) / 2),
          Text(
            'Remember me',
            style: AppTheme.bodySmall(context).copyWith(
              color: hasError ? AppTheme.error : null,
            ),
          ),
        ],
      );
    });
  }

  // Helper method to build the forgot password link
  Widget _buildForgotPassword(BuildContext context) {
    return TextButton(
      onPressed: () {
        Get.toNamed('/forgotpassword');
      },
      child: Text(
        'Forgot Password?',
        style: AppTheme.bodySmall(
          context,
        ).copyWith(color: AppTheme.accentColor),
      ),
    );
  }
}
