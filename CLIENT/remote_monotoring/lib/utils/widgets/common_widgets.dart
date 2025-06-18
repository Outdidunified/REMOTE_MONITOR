import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remote_monotoring/utils/Layouts/responsive_layout.dart';
import 'package:remote_monotoring/utils/theme/app_theme.dart';
import 'package:pinput/pinput.dart'; // Add this import at the top


/// A collection of common widgets used throughout the application
class CommonWidgets {
  /// Creates a responsive card with consistent styling
  static Widget card({
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry? padding,
    double? width,
    double? height,
    Color? backgroundColor,
    BoxBorder? border,
    List<BoxShadow>? boxShadow,
  }) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? ResponsiveLayout.responsivePadding(context),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.backgroundMedium,
        borderRadius: BorderRadius.circular(
          ResponsiveLayout.borderRadius(context),
        ),
        border: border,
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
      ),
      child: child,
    );
  }

  static Widget pinInputField({
    required BuildContext context,
    required int length,
    required TextEditingController controller,
    EdgeInsetsGeometry? padding,
    String? Function(String?)? validator, // <-- Accept validator
  }) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: FormField<String>(
        validator: (_) => validator?.call(controller.text),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        builder: (formFieldState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Pinput(
                length: length,
                controller: controller,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsRetrieverApi,

                defaultPinTheme: PinTheme(
                  width: 50,
                  height: 56,
                  textStyle: const TextStyle(
                      fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                focusedPinTheme: PinTheme(
                  width: 50,
                  height: 56,
                  textStyle: const TextStyle(
                      fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (_) => formFieldState.didChange(controller.text),
              ),
              if (formFieldState.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 4),
                  child: Text(
                    formFieldState.errorText!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }



  static Widget logoCircle(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentColor.withOpacity(0.5),
            blurRadius: 25,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Container(
        width: ResponsiveLayout.widthPercent(
          context,
          percent: 0.2,
          tabletPercent: 0.15,
          desktopPercent: 0.1,
        ),
        height: ResponsiveLayout.widthPercent(
          context,
          percent: 0.2,
          tabletPercent: 0.15,
          desktopPercent: 0.1,
        ),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppTheme.accentRadialGradient,
        ),
        child: Image.asset(
          'assets/icons/virtual-desktop.png',
          width: screenWidth * 0.5,
          color: Colors.white, // tint image if it's monochrome
        ),
      ),
    );
  }

  /// Creates a responsive button with consistent styling
  static Widget primaryButton({
    required BuildContext context,
    required String text,
    required VoidCallback? onPressed, // Nullable to allow disabling
    bool isLoading = false,
    IconData? icon,
    double? width,
  }) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: AppTheme.primaryButtonStyle,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child:
              isLoading
                  ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                  : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          size: ResponsiveLayout.iconSize(context) * 0.8,
                        ),
                        SizedBox(width: ResponsiveLayout.spacing(context) / 2),
                      ],
                      Text(
                        text,
                        style: AppTheme.bodyMedium(
                          context,
                        ).copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  /// Creates a responsive secondary button with consistent styling
  static Widget secondaryButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    IconData? icon,
    double? width,
  }) {
    return SizedBox(
      width: width,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: AppTheme.secondaryButtonStyle,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child:
              isLoading
                  ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.accentColor,
                    ),
                  )
                  : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          size: ResponsiveLayout.iconSize(context) * 0.8,
                        ),
                        SizedBox(width: ResponsiveLayout.spacing(context) / 2),
                      ],
                      Text(
                        text,
                        style: AppTheme.bodyMedium(
                          context,
                        ).copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  /// Creates a responsive text input field with consistent styling
  static Widget textField({
    required BuildContext context,
    required String label,
    required String hint,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    IconData? prefixIcon,
    IconData? suffixIcon,
    VoidCallback? onSuffixIconPressed,
    int? maxLines = 1,
    int? maxLength,
    bool readOnly = false,                      // 🔒 NEW: readOnly support
    Color? fillColor,                           // 🎨 NEW: fill color customization
    TextStyle? style,                           // ✍️ NEW: override text style
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      maxLength: maxLength,
      readOnly: readOnly,                       // ← Apply readOnly
      style: style ?? AppTheme.bodyMedium(context),
      decoration: AppTheme.inputDecoration(label, hint).copyWith(
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null
            ? IconButton(
          icon: Icon(suffixIcon),
          onPressed: onSuffixIconPressed,
        )
            : null,
        filled: fillColor != null,
        fillColor: fillColor,                   // ← Apply fillColor
      ),
    );
  }


  /// Creates a responsive dropdown with consistent styling
  static Widget dropdown<T>({
    required BuildContext context,
    required String label,
    required String hint,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
    IconData? prefixIcon,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      style: AppTheme.bodyMedium(context),
      decoration: AppTheme.inputDecoration(
        label,
        hint,
      ).copyWith(prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null),
      dropdownColor: AppTheme.backgroundLight,
    );
  }

  /// Creates a responsive section header with consistent styling
  static Widget sectionHeader({
    required BuildContext context,
    required String title,
    String? subtitle,
    Widget? trailing,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTheme.headingMedium(context)),
            if (trailing != null) trailing,
          ],
        ),
        if (subtitle != null) ...[
          SizedBox(height: ResponsiveLayout.spacing(context) / 2),
          Text(subtitle, style: AppTheme.bodySmall(context)),
        ],
        SizedBox(height: ResponsiveLayout.spacing(context)),
      ],
    );
  }

  /// Creates a responsive divider with consistent styling
  static Widget divider(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveLayout.spacing(context),
      ),
      child: const Divider(color: AppTheme.textMuted, thickness: 0.5),
    );
  }

  /// Creates a responsive status indicator with consistent styling
  static Widget statusIndicator({
    required BuildContext context,
    required String label,
    required bool isActive,
    String? description,
  }) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppTheme.success : AppTheme.error,
          ),
        ),
        SizedBox(width: ResponsiveLayout.spacing(context) / 2),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTheme.bodyMedium(context)),
            if (description != null)
              Text(description, style: AppTheme.caption(context)),
          ],
        ),
      ],
    );
  }

  /// Creates a responsive loading indicator with consistent styling
  static Widget loadingIndicator(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppTheme.accentColor),
          SizedBox(height: ResponsiveLayout.spacing(context)),
          Text('Loading...', style: AppTheme.bodyMedium(context)),
        ],
      ),
    );
  }

  /// Creates a responsive error message with consistent styling
  static Widget errorMessage({
    required BuildContext context,
    required String message,
    VoidCallback? onRetry,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: AppTheme.error, size: 48),
          SizedBox(height: ResponsiveLayout.spacing(context)),
          Text(
            message,
            style: AppTheme.bodyMedium(context),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            SizedBox(height: ResponsiveLayout.spacing(context)),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }

  /// Creates a responsive empty state with consistent styling
  static Widget emptyState({
    required BuildContext context,
    required String message,
    IconData icon = Icons.inbox,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppTheme.textMuted, size: 48),
          SizedBox(height: ResponsiveLayout.spacing(context)),
          Text(
            message,
            style: AppTheme.bodyMedium(context),
            textAlign: TextAlign.center,
          ),
          if (onAction != null && actionLabel != null) ...[
            SizedBox(height: ResponsiveLayout.spacing(context)),
            TextButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.add),
              label: Text(actionLabel),
            ),
          ],
        ],
      ),
    );
  }

  /// Creates a responsive app bar with consistent styling
  static PreferredSizeWidget appBar({
    required BuildContext context,
    required String title,
    List<Widget>? actions,
    bool centerTitle = true,
    PreferredSizeWidget? bottom,
    Widget? leading,
  }) {
    return AppBar(
      title: Text(title, style: AppTheme.headingSmall(context)),
      centerTitle: centerTitle,
      backgroundColor: AppTheme.primaryDark,
      elevation: 0,
      actions: actions,
      bottom: bottom,
      leading: leading,
    );
  }

  /// Creates a responsive drawer with consistent styling
  static Widget drawer({
    required BuildContext context,
    required String title,
    required List<Widget> items,
    Widget? header,
    Widget? footer,
  }) {
    return Drawer(
      backgroundColor: AppTheme.backgroundDark,
      child: Column(
        children: [
          header ??
              DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                ),
                child: Center(
                  child: Text(title, style: AppTheme.headingMedium(context)),
                ),
              ),
          Expanded(child: ListView(padding: EdgeInsets.zero, children: items)),
          if (footer != null) footer,
        ],
      ),
    );
  }

  /// Creates a responsive drawer item with consistent styling
  static Widget drawerItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppTheme.accentColor : AppTheme.textPrimary,
      ),
      title: Text(
        title,
        style: AppTheme.bodyMedium(context).copyWith(
          color: isSelected ? AppTheme.accentColor : AppTheme.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: onTap,
      tileColor: isSelected ? AppTheme.primaryDark.withOpacity(0.3) : null,
    );
  }

  /// Creates a responsive background with circuit pattern
  static Widget circuitBackground({
    required BuildContext context,
    required Widget child,
    Color patternColor = Colors.white,
    double opacity = 0.1,
  }) {
    return Stack(
      children: [
        Positioned.fill(
          child: Opacity(
            opacity: opacity,
            child: CustomPaint(
              painter: CircuitPatternPainter(
                color: patternColor,
                opacity: 1.0, // We're already using an opacity widget
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }


}
