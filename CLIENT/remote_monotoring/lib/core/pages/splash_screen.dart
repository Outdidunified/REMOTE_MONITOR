import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:remote_monotoring/core/controllers/session_controller.dart';
import 'package:remote_monotoring/utils/debug/build_guard.dart';
import 'package:remote_monotoring/features/auth/presentation/pages/login_page.dart';
import 'package:remote_monotoring/features/Dashboard/presentation/pages/dashboard_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Don't find the controller immediately - we'll check for it later
  SessionController? _sessionController;
  bool _hasNavigated = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    // Try to initialize after a short delay to allow GetX to set up
    _initializeWithDelay();
  }

  void _initializeWithDelay() {
    // Delay to allow controllers to be registered
    Future.delayed(const Duration(milliseconds: 500), () {
      _tryInitializeController();
    });
  }

  // Counter to limit retry attempts
  int _retryCount = 0;
  static const int _maxRetries = 10;

  void _tryInitializeController() {
    if (_isInitialized) return;

    // Increment retry counter
    _retryCount++;

    try {
      // Try to find the SessionController
      if (Get.isRegistered<SessionController>()) {
        _sessionController = Get.find<SessionController>();
        _setupNavigation();
        _isInitialized = true;
      } else if (_retryCount < _maxRetries) {
        // If not found and we haven't exceeded max retries, try again after a delay
        Future.delayed(
          const Duration(milliseconds: 500),
          _tryInitializeController,
        );
      } else {
        // If we've exceeded max retries, navigate to GetStartedPage as fallback
        debugPrint(
          'Max retries exceeded, navigating to GetStartedPage as fallback',
        );
        _navigateToFallback();
      }
    } catch (e) {
      debugPrint('Error initializing SessionController: $e');
      if (_retryCount < _maxRetries) {
        // Try again after a delay if we haven't exceeded max retries
        Future.delayed(
          const Duration(milliseconds: 500),
          _tryInitializeController,
        );
      } else {
        // Navigate to fallback if max retries exceeded
        _navigateToFallback();
      }
    }
  }

  void _navigateToFallback() {
    if (!_hasNavigated) {
      _hasNavigated = true;
      // Use a safe navigation approach
      BuildGuard.runSafely(() {
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAll(
            () => LoginPage(),
            transition: Transition.rightToLeft,
            duration: Duration(milliseconds: 600),
          );
        });
      });
    }
  }

  void _setupNavigation() {
    if (_sessionController == null) return;

    // Set up the listener for login state changes
    ever(_sessionController!.isLoggedIn, (isLoggedIn) {
      BuildGuard.runSafely(() async {
        if (_hasNavigated) return;
        _hasNavigated = true;

        await Future.delayed(const Duration(seconds: 3)); // wait 3 sec after animation

        if (isLoggedIn) {
          debugPrint("Navigating to Dashboard");
          Get.offAll(
                () => DashboardPage(),
            transition: Transition.rightToLeft,
            duration: Duration(milliseconds: 600),
          );
        } else {
          debugPrint("Navigating to LoginPage");
          Get.offAll(
                () => LoginPage(),
            transition: Transition.rightToLeft,
            duration: Duration(milliseconds: 600),
          );
        }
      });
    });

    // Check login state after a delay to allow animation to complete
    Future.delayed(const Duration(seconds: 2), () {
      if (_sessionController != null) {
        _sessionController!.isLoggedIn.refresh();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    // MediaQuery for responsiveness
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1A237E), // Deep blue
              Color(0xFF3949AB), // Indigo
              Color(0xFF303F9F), // Dark indigo
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Background circuit pattern
            Positioned.fill(
              child: Opacity(
                opacity: 0.1,
                child: CustomPaint(painter: CircuitPatternPainter()),
              ),
            ),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo animation with glow effect
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF4FC3F7).withOpacity(0.5),
                          blurRadius: 25,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.elasticOut,
                      builder: (context, double scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: Container(
                            width: screenWidth * 0.28,
                            height: screenWidth * 0.28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Color(0xFF4FC3F7), // Light blue
                                  Color(0xFF0288D1), // Blue
                                ],
                              ),
                            ),
                            child: Image.asset(
                              'assets/icons/virtual-desktop.png',
                              width: screenWidth * 0.5,
                              color:
                                  Colors
                                      .white, // Optional: will tint image if it's monochrome
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.05),

                  // Animated text with pulse effect
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 1000),
                    builder: (context, double opacity, child) {
                      return Opacity(
                        opacity: opacity,
                        child: Column(
                          children: [
                            // Main title with animated typing effect
                            DefaultTextStyle(
                              style: GoogleFonts.rajdhani(
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    'REMOTE MONITORING',
                                    speed: Duration(milliseconds: 150),
                                  ),
                                ],
                                totalRepeatCount: 1,
                                displayFullTextOnTap: true,
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.02),

                            // Subtitle with fade-in effect
                            Text(
                              'Advanced System Monitoring',
                              style: GoogleFonts.rajdhani(
                                fontSize: screenWidth * 0.03,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF4FC3F7),
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  SizedBox(height: screenHeight * 0.06),

                  // Animated loading indicator
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    builder: (context, double opacity, child) {
                      return Opacity(
                        opacity: opacity,
                        child: Container(
                          width: screenWidth * 0.4,
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.white24,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF4FC3F7),
                            ),
                            minHeight: 5,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Version number at bottom
            Positioned(
              bottom: 20,
              right: 20,
              child: Text(
                'v1.0.0',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for circuit pattern background
class CircuitPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.3)
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;

    final random = Random(42); // Fixed seed for consistent pattern

    // Draw horizontal and vertical lines
    for (int i = 0; i < 20; i++) {
      double x = random.nextDouble() * size.width;
      double y = random.nextDouble() * size.height;
      double length = 20 + random.nextDouble() * 100;

      // Horizontal or vertical line
      if (random.nextBool()) {
        canvas.drawLine(Offset(x, y), Offset(x + length, y), paint);
      } else {
        canvas.drawLine(Offset(x, y), Offset(x, y + length), paint);
      }

      // Add some circles at endpoints
      if (random.nextBool()) {
        canvas.drawCircle(Offset(x, y), 2 + random.nextDouble() * 3, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
