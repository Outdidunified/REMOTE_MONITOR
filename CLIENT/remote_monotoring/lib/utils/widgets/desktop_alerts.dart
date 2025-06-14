import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remote_monotoring/utils/Layouts/responsive_layout.dart';
import 'package:remote_monotoring/utils/theme/app_theme.dart';

/// A utility class for showing desktop-specific alerts with smooth animations
class DesktopAlerts {
  /// Shows a success alert dialog with desktop-specific styling
  static Future<void> showSuccessAlert({
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onConfirm,
  }) async {
    return _showAnimatedAlert(
      icon: Icons.check_circle_outline,
      iconColor: AppTheme.success,
      title: title,
      message: message,
      buttonText: buttonText ?? 'OK',
      onConfirm: onConfirm,
      gradient: const LinearGradient(
        colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

  /// Shows an error alert dialog with desktop-specific styling
  static Future<void> showErrorAlert({
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onConfirm,
  }) async {
    return _showAnimatedAlert(
      icon: Icons.error_outline,
      iconColor: AppTheme.error,
      title: title,
      message: message,
      buttonText: buttonText ?? 'OK',
      onConfirm: onConfirm,
      gradient: const LinearGradient(
        colors: [Color(0xFFE53935), Color(0xFFC62828)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

  /// Shows an info alert dialog with desktop-specific styling
  static Future<void> showInfoAlert({
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onConfirm,
  }) async {
    return _showAnimatedAlert(
      icon: Icons.info_outline,
      iconColor: AppTheme.info,
      title: title,
      message: message,
      buttonText: buttonText ?? 'OK',
      onConfirm: onConfirm,
      gradient: const LinearGradient(
        colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

  /// Shows a warning alert dialog with desktop-specific styling
  static Future<void> showWarningAlert({
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onConfirm,
  }) async {
    return _showAnimatedAlert(
      icon: Icons.warning_amber_outlined,
      iconColor: AppTheme.warning,
      title: title,
      message: message,
      buttonText: buttonText ?? 'OK',
      onConfirm: onConfirm,
      gradient: const LinearGradient(
        colors: [Color(0xFFFFA000), Color(0xFFFF8F00)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

  /// Shows a confirmation alert dialog with desktop-specific styling
  static Future<bool> showConfirmationAlert({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) async {
    final result = await Get.dialog<bool>(
      _buildAnimatedDialog(
        icon: Icons.help_outline,
        iconColor: AppTheme.info,
        title: title,
        message: message,
        gradient: const LinearGradient(
          colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              cancelText,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primaryDark,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    return result ?? false;
  }

  /// Shows a toast message with desktop-specific styling
  static void showToast(
    String message, {
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      isError ? 'Error' : 'Information',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor:
          isError
              ? AppTheme.error.withOpacity(0.9)
              : AppTheme.primaryDark.withOpacity(0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: duration,
      animationDuration: const Duration(milliseconds: 300),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      icon: Icon(
        isError ? Icons.error_outline : Icons.info_outline,
        color: Colors.white,
      ),
      shouldIconPulse: true,
      mainButton: TextButton(
        onPressed: () => Get.back(),
        child: const Text('DISMISS', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  /// Private method to show an animated alert dialog
  static Future<void> _showAnimatedAlert({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
    required String buttonText,
    required LinearGradient gradient,
    VoidCallback? onConfirm,
  }) async {
    await Get.dialog(
      _buildAnimatedDialog(
        icon: icon,
        iconColor: iconColor,
        title: title,
        message: message,
        gradient: gradient,
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
              if (onConfirm != null) onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primaryDark,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(buttonText),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// Builds an animated dialog with consistent styling
  static Widget _buildAnimatedDialog({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
    required LinearGradient gradient,
    required List<Widget> actions,
  }) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 300),
        tween: Tween<double>(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: 0.5 + (0.5 * value),
            child: Opacity(opacity: value, child: child),
          );
        },
        child: Container(
          width: ResponsiveLayout.widthPercent(
            Get.context!,
            percent: 0.9,
            tabletPercent: 0.6,
            desktopPercent: 0.4,
            largeDesktopPercent: 0.3,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppTheme.backgroundMedium,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with gradient
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(icon, color: Colors.white, size: 36),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Message body
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),

              // Action buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
