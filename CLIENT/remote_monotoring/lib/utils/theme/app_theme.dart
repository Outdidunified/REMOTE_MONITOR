import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// AppTheme defines the consistent styling for the entire application
class AppTheme {
  // Primary colors
  static const Color primaryDark = Color(0xFF1A237E); // Deep blue
  static const Color primary = Color(0xFF3949AB); // Indigo
  static const Color primaryLight = Color(0xFF303F9F); // Dark indigo

  // Accent colors
  static const Color accentColor = Color(0xFF4FC3F7); // Light blue
  static const Color accentDark = Color(0xFF0288D1); // Blue

  // Text colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFE0E0E0);
  static const Color textMuted = Color(0xFFBDBDBD);

  // Background colors
  static const Color backgroundDark = Color(0xFF121212);
  static const Color backgroundMedium = Color(0xFF1E1E1E);
  static const Color backgroundLight = Color(0xFF2C2C2C);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryDark, primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const RadialGradient accentRadialGradient = RadialGradient(
    colors: [accentColor, accentDark],
  );

  // Text styles
  static TextStyle headingLarge(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return GoogleFonts.rajdhani(
      fontSize: _responsiveFontSize(screenWidth, 32, 48),
      fontWeight: FontWeight.bold,
      color: textPrimary,
      letterSpacing: 1.5,
    );
  }

  static TextStyle headingMedium(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return GoogleFonts.rajdhani(
      fontSize: _responsiveFontSize(screenWidth, 24, 32),
      fontWeight: FontWeight.bold,
      color: textPrimary,
      letterSpacing: 1.2,
    );
  }

  static TextStyle headingSmall(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return GoogleFonts.rajdhani(
      fontSize: _responsiveFontSize(screenWidth, 18, 24),
      fontWeight: FontWeight.bold,
      color: textPrimary,
      letterSpacing: 1.0,
    );
  }

  static TextStyle bodyLarge(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return GoogleFonts.poppins(
      fontSize: _responsiveFontSize(screenWidth, 16, 18),
      fontWeight: FontWeight.normal,
      color: textPrimary,
    );
  }

  static TextStyle bodyMedium(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return GoogleFonts.poppins(
      fontSize: _responsiveFontSize(screenWidth, 14, 16),
      fontWeight: FontWeight.normal,
      color: textPrimary,
    );
  }

  static TextStyle bodySmall(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return GoogleFonts.poppins(
      fontSize: _responsiveFontSize(screenWidth, 12, 14),
      fontWeight: FontWeight.normal,
      color: textSecondary,
    );
  }

  static TextStyle caption(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return GoogleFonts.poppins(
      fontSize: _responsiveFontSize(screenWidth, 10, 12),
      fontWeight: FontWeight.normal,
      color: textMuted,
    );
  }

  // Button styles
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: accentColor,
    foregroundColor: textPrimary,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  static ButtonStyle secondaryButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: accentColor,
    side: const BorderSide(color: accentColor),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  // Card styles
  static BoxDecoration cardDecoration = BoxDecoration(
    color: backgroundMedium,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Input decoration
  static InputDecoration inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: textSecondary),
      hintStyle: const TextStyle(color: textMuted),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primary),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: accentColor, width: 2),
      ),
      filled: true,
      fillColor: backgroundLight,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  // Helper method for responsive font sizing
  static double _responsiveFontSize(
    double screenWidth,
    double minSize,
    double maxSize,
  ) {
    // Base calculation on a range from 800px to 1920px screen width
    const double minWidth = 800;
    const double maxWidth = 1920;

    if (screenWidth <= minWidth) return minSize;
    if (screenWidth >= maxWidth) return maxSize;

    // Calculate a size proportional to the screen width
    final double factor = (screenWidth - minWidth) / (maxWidth - minWidth);
    return minSize + (maxSize - minSize) * factor;
  }

  // Create a ThemeData instance for the app
  static ThemeData themeData(BuildContext context) {
    return ThemeData(
      primaryColor: primary,
      scaffoldBackgroundColor: backgroundDark,
      textTheme: GoogleFonts.poppinsTextTheme(
        Theme.of(context).textTheme,
      ).apply(bodyColor: textPrimary, displayColor: textPrimary),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryDark,
        foregroundColor: textPrimary,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(style: primaryButtonStyle),
      outlinedButtonTheme: OutlinedButtonThemeData(style: secondaryButtonStyle),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: accentColor),
      ),
      iconTheme: const IconThemeData(color: textPrimary),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: accentColor,
        linearTrackColor: Colors.white24,
      ),
      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: accentColor,
        surface: backgroundMedium,
        background: backgroundDark,
        error: error,
      ),
    );
  }
}

// Custom circuit pattern painter for backgrounds
class CircuitPatternPainter extends CustomPainter {
  final Color color;
  final double opacity;

  CircuitPatternPainter({this.color = Colors.white, this.opacity = 0.3});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color.withOpacity(opacity)
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;

    final random = Random(42); // Fixed seed for consistent pattern

    // Calculate number of elements based on size
    final int elementCount = (size.width * size.height / 20000).round().clamp(
      10,
      50,
    );

    // Draw horizontal and vertical lines
    for (int i = 0; i < elementCount; i++) {
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
