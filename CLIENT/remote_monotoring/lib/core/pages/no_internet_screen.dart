// lib/core/pages/no_internet_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remote_monotoring/core/controllers/connectivity_controller.dart';
import 'package:remote_monotoring/utils/Layouts/responsive_layout.dart';
import 'package:remote_monotoring/utils/theme/app_theme.dart';
import 'package:remote_monotoring/utils/widgets/common_widgets.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final RxBool _isRetrying = false.obs;
  final RxString _statusMessage = 'Please check your network settings.'.obs;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
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

  void _retryConnection() async {
    final controller = Get.find<ConnectivityController>();

    _isRetrying.value = true;
    _statusMessage.value = 'Checking connection...';

    await Future.delayed(const Duration(seconds: 1));

    await controller.checkConnection();

    if (controller.isConnected.value) {
      _statusMessage.value = 'Connection restored! Redirecting...';
      await Future.delayed(const Duration(milliseconds: 500));

      // Use the controller's method to navigate back to the previous route
      if (controller.lastRoute != null &&
          controller.lastRoute != '/noInternet') {
        Get.offAllNamed(controller.lastRoute!);
      } else {
        // Fallback to dashboard if no previous route
        Get.offAllNamed('/dashboard');
      }
    } else {
      _statusMessage.value =
          'Still no connection. Please check your network settings.';
      _isRetrying.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // disables back button
      child: Scaffold(
        backgroundColor: AppTheme.backgroundDark,
        body: CommonWidgets.circuitBackground(
          context: context,
          opacity: 0.05,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(scale: _scaleAnimation, child: child),
              );
            },
            child: Center(
              child: Padding(
                padding: ResponsiveLayout.responsivePadding(context),
                child: CommonWidgets.card(
                  context: context,
                  width: ResponsiveLayout.widthPercent(
                    context,
                    percent: 0.9,
                    tabletPercent: 0.6,
                    desktopPercent: 0.4,
                    largeDesktopPercent: 0.3,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated icon
                      TweenAnimationBuilder<double>(
                        duration: const Duration(seconds: 2),
                        tween: Tween<double>(begin: 0, end: 1),
                        curve: Curves.elasticOut,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: 0.5 + (value * 0.5),
                            child: child,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.error.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.wifi_off_rounded,
                            size: ResponsiveLayout.iconSize(context) * 2,
                            color: AppTheme.error,
                          ),
                        ),
                      ),

                      SizedBox(height: ResponsiveLayout.spacing(context)),

                      // Title
                      Text(
                        'No Internet Connection',
                        style: AppTheme.headingMedium(context),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: ResponsiveLayout.spacing(context) / 2),

                      // Status message
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            _statusMessage.value,
                            style: AppTheme.bodyMedium(context),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      SizedBox(height: ResponsiveLayout.spacing(context) * 1.5),

                      // Retry button
                      Obx(
                        () => CommonWidgets.primaryButton(
                          context: context,
                          text: 'Retry Connection',
                          icon: Icons.refresh_rounded,
                          onPressed: _retryConnection,
                          isLoading: _isRetrying.value,
                        ),
                      ),

                      SizedBox(height: ResponsiveLayout.spacing(context)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
