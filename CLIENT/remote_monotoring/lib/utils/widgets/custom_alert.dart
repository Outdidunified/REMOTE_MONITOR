import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remote_monotoring/utils/Layouts/responsive_layout.dart';
import 'package:remote_monotoring/utils/theme/app_theme.dart';
import 'package:remote_monotoring/utils/widgets/common_widgets.dart';

/// A custom alert dialog with consistent styling
class CustomAlert {
  /// Shows a custom alert dialog
  static Future<T?> show<T>({
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    IconData? icon,
    Color? iconColor,
    bool isDismissible = true,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return Get.dialog<T>(
      WillPopScope(
        onWillPop: () async => isDismissible,
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: CommonWidgets.card(
            context: Get.context!,
            width: ResponsiveLayout.widthPercent(
              Get.context!,
              percent: 0.9,
              tabletPercent: 0.6,
              desktopPercent: 0.4,
              largeDesktopPercent: 0.3,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: (iconColor ?? AppTheme.primary).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: ResponsiveLayout.iconSize(Get.context!) * 1.5,
                      color: iconColor ?? AppTheme.primary,
                    ),
                  ),
                  SizedBox(height: ResponsiveLayout.spacing(Get.context!)),
                ],
                Text(
                  title,
                  style: AppTheme.headingSmall(Get.context!),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ResponsiveLayout.spacing(Get.context!) / 2),
                Text(
                  message,
                  style: AppTheme.bodyMedium(Get.context!),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ResponsiveLayout.spacing(Get.context!) * 1.5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (cancelText != null)
                      Expanded(
                        child: CommonWidgets.secondaryButton(
                          context: Get.context!,
                          text: cancelText,
                          onPressed: () {
                            Get.back();
                            if (onCancel != null) onCancel();
                          },
                        ),
                      ),
                    if (cancelText != null && confirmText != null)
                      SizedBox(width: ResponsiveLayout.spacing(Get.context!)),
                    if (confirmText != null)
                      Expanded(
                        child: CommonWidgets.primaryButton(
                          context: Get.context!,
                          text: confirmText,
                          onPressed: () {
                            Get.back();
                            if (onConfirm != null) onConfirm();
                          },
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: isDismissible,
    );
  }

  /// Shows a success alert dialog
  static Future<T?> success<T>({
    String title = 'Success',
    required String message,
    String confirmText = 'OK',
    VoidCallback? onConfirm,
  }) {
    return show<T>(
      title: title,
      message: message,
      confirmText: confirmText,
      icon: Icons.check_circle,
      iconColor: AppTheme.success,
      onConfirm: onConfirm,
    );
  }

  /// Shows an error alert dialog
  static Future<T?> error<T>({
    String title = 'Error',
    required String message,
    String confirmText = 'OK',
    VoidCallback? onConfirm,
  }) {
    return show<T>(
      title: title,
      message: message,
      confirmText: confirmText,
      icon: Icons.error,
      iconColor: AppTheme.error,
      onConfirm: onConfirm,
    );
  }

  /// Shows a warning alert dialog
  static Future<T?> warning<T>({
    String title = 'Warning',
    required String message,
    String confirmText = 'OK',
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return show<T>(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      icon: Icons.warning,
      iconColor: AppTheme.warning,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
  }

  /// Shows a confirmation alert dialog
  static Future<T?> confirm<T>({
    String title = 'Confirm',
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return show<T>(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      icon: Icons.help,
      iconColor: AppTheme.info,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
  }
}
