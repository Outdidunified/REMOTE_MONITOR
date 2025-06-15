import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:remote_monotoring/core/pages/no_internet_screen.dart';
import 'package:remote_monotoring/features/auth/domain/repositories/auth_repository.dart' show AuthRepository;
import 'package:remote_monotoring/features/auth/presentation/pages/forgotpassword_page.dart';
import 'package:remote_monotoring/features/auth/presentation/pages/login_page.dart';
import 'package:remote_monotoring/features/auth/presentation/pages/register_page.dart';
import 'package:remote_monotoring/features/Dashboard/presentation/pages/dashboard_page.dart';
import 'package:remote_monotoring/features/ManageDevice/pages/ManageDevicePage.dart';
import 'package:remote_monotoring/features/History/pages/HistoryPage.dart';
import 'package:remote_monotoring/features/Analytics/pages/Analyticspage.dart';
import 'package:remote_monotoring/features/Settings/pages/SettingsPage.dart';
import 'package:remote_monotoring/utils/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:remote_monotoring/core/controllers/session_controller.dart';
import 'package:remote_monotoring/core/controllers/connectivity_controller.dart';
import 'package:remote_monotoring/core/controllers/navigation_controller.dart';
import 'package:remote_monotoring/core/pages/splash_screen.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations for desktop
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Initialize controllers
  final sessionController = SessionController(prefs: prefs);
  final connectivityController = ConnectivityController();
  final navigationController = NavigationController();

  // Register controllers with GetX
  Get.put(sessionController);
  Get.put(connectivityController);
  Get.put(navigationController);
  Get.put(AuthRepository());

  // Allow self-signed certificates for development
  HttpOverrides.global = MyHttpOverrides();

  // Run the app
  runApp(const RemoteMonitoring());
}

class RemoteMonitoring extends StatelessWidget {
  const RemoteMonitoring({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Remote Monitoring',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData(context),

      // Default transition for all routes
      defaultTransition: Transition.fadeIn,

      // Transition duration for smoother animations
      transitionDuration: const Duration(milliseconds: 300),

      // Default route
      initialRoute: '/',

      // Define all routes with consistent transitions
      getPages: [
        GetPage(
          name: '/',
          page: () => const SplashScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/LoginPage',
          page: () => const LoginPage(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/noInternet',
          page: () => const NoInternetScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/register',
          page: () => RegisterPage(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/forgotpassword',
          page: () => ForgotpasswordPage(),
          transition: Transition.fadeIn,
        ),
        // Dashboard and feature pages
        GetPage(
          name: '/dashboard',
          page: () => DashboardPage(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/manageDevices',
          page: () => Managedevicepage(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/history',
          page: () => Historypage(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/analytics',
          page: () => Analyticspage(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/settings',
          page: () => Settingspage(),
          transition: Transition.fadeIn,
        ),
      ],
    );
  }
}

/// Custom HTTP overrides to handle self-signed certificates
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
