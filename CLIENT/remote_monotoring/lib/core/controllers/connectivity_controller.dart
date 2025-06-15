import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remote_monotoring/utils/debug/build_guard.dart';
import 'package:remote_monotoring/utils/widgets/desktop_alerts.dart';

/// Controller responsible for monitoring and managing internet connectivity
class ConnectivityController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _subscription;

  // Observable state
  final RxBool isConnected = true.obs;
  final RxBool isCheckingConnection = false.obs;

  // Store the last valid route before losing connection
  String? lastRoute;

  // Debounce timer to prevent rapid UI changes on fluctuating connections
  Timer? _debounceTimer;

  @override
  void onInit() {
    super.onInit();

    // Slight delay to ensure app is fully initialized
    Future.delayed(const Duration(milliseconds: 500), () {
      checkConnection();
      _subscription = _connectivity.onConnectivityChanged.listen(
        _handleConnectivityChange,
      );
    });
  }

  /// Manually triggered by retry button in UI
  void refreshConnectionAndNavigate() async {
    if (isCheckingConnection.value) return;

    isCheckingConnection.value = true;
    await checkConnection();

    // If connected and we have a valid route to return to
    if (isConnected.value && lastRoute != null && lastRoute != '/noInternet') {
      Get.offNamed(lastRoute!);
    }

    isCheckingConnection.value = false;
  }

  /// Perform a one-time connectivity check
  Future<void> checkConnection() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _processConnectionStatus(result);
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      isConnected.value = false;
    }
  }

  /// Initial handler for connectivity changes with debounce
  void _handleConnectivityChange(ConnectivityResult result) {
    // Cancel any existing timer
    _debounceTimer?.cancel();

    // Set a debounce to avoid rapid UI changes on fluctuating connections
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _processConnectionStatus(result);
    });
  }

  /// Process the connection status after debounce
  void _processConnectionStatus(ConnectivityResult result) {
    BuildGuard.runSafely(() {
      // Store previous state to detect changes
      final bool wasConnected = isConnected.value;

      // Update current state
      isConnected.value = (result != ConnectivityResult.none);

      // Skip navigation if GetX context is not ready
      if (Get.context == null) {
        debugPrint('GetX context not available, skipping navigation');
        return;
      }

      // Verify GetX navigation is ready
      try {
        final _ = Get.currentRoute;
      } catch (e) {
        debugPrint('GetX navigation not ready: $e');
        return;
      }

      // Handle connection lost
      if (!isConnected.value) {
        _handleConnectionLost();
      }
      // Handle connection restored
      else if (!wasConnected && isConnected.value) {
        _handleConnectionRestored();
      }
    });
  }

  /// Handle actions when connection is lost
  void _handleConnectionLost() {
    // Save the current route if not already on no internet screen
    if (lastRoute == null || lastRoute != '/noInternet') {
      try {
        lastRoute = Get.currentRoute.isNotEmpty ? Get.currentRoute : '/';
      } catch (e) {
        lastRoute = '/';
      }

      debugPrint('Connection lost. Saving route: $lastRoute');
    }

    // Navigate to NoInternetScreen if not already there
    if (Get.currentRoute != '/noInternet') {
      try {
        // Navigate to no internet screen
        Get.toNamed('/noInternet');
      } catch (e) {
        debugPrint('Navigation error to noInternet: $e');
      }
    }
  }

  /// Handle actions when connection is restored
  void _handleConnectionRestored() {
    // If we have a valid route to return to
    if (lastRoute != null && lastRoute != '/noInternet') {
      try {
        debugPrint('Connection restored. Returning to: $lastRoute');

        // Navigate back to the previous route
        Get.offAllNamed(lastRoute!);

        // Show a success toast
        DesktopAlerts.showToast(
          'Internet connection restored',
          isError: false,
          duration: const Duration(seconds: 2),
        );
      } catch (e) {
        debugPrint('Navigation error returning to lastRoute: $e');
      }
    }
  }

  @override
  void onClose() {
    _subscription.cancel();
    _debounceTimer?.cancel();
    super.onClose();
  }
}
