import 'package:flutter/material.dart';

/// ResponsiveLayout provides utilities for creating responsive layouts
class ResponsiveLayout {
  // Screen size breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
  static const double largeDesktopBreakpoint = 1800;

  /// Returns true if the screen width is less than the mobile breakpoint
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  /// Returns true if the screen width is between mobile and tablet breakpoints
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }

  /// Returns true if the screen width is between tablet and large desktop breakpoints
  static bool isDesktop(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= desktopBreakpoint && width < largeDesktopBreakpoint;
  }

  /// Returns true if the screen width is greater than the large desktop breakpoint
  static bool isLargeDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= largeDesktopBreakpoint;
  }

  /// Returns a value based on the current screen size
  static T value<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) {
    // Use mobile as fallback for tablet if not specified
    final effectiveTablet = tablet ?? mobile;
    // Use tablet as fallback for desktop if not specified
    final effectiveDesktop = desktop ?? effectiveTablet;
    // Use desktop as fallback for large desktop if not specified
    final effectiveLargeDesktop = largeDesktop ?? effectiveDesktop;

    if (isLargeDesktop(context)) {
      return effectiveLargeDesktop;
    } else if (isDesktop(context)) {
      return effectiveDesktop;
    } else if (isTablet(context)) {
      return effectiveTablet;
    } else {
      return mobile;
    }
  }

  /// Returns a responsive padding based on screen size
  static EdgeInsets responsivePadding(BuildContext context) {
    return value<EdgeInsets>(
      context: context,
      mobile: const EdgeInsets.all(16),
      tablet: const EdgeInsets.all(24),
      desktop: const EdgeInsets.all(32),
      largeDesktop: const EdgeInsets.all(48),
    );
  }

  /// Returns a responsive horizontal padding based on screen size
  static EdgeInsets responsiveHorizontalPadding(BuildContext context) {
    return value<EdgeInsets>(
      context: context,
      mobile: const EdgeInsets.symmetric(horizontal: 16),
      tablet: const EdgeInsets.symmetric(horizontal: 48),
      desktop: const EdgeInsets.symmetric(horizontal: 96),
      largeDesktop: const EdgeInsets.symmetric(horizontal: 192),
    );
  }

  /// Returns a responsive spacing value based on screen size
  static double spacing(BuildContext context) {
    return value<double>(
      context: context,
      mobile: 8,
      tablet: 16,
      desktop: 24,
      largeDesktop: 32,
    );
  }

  /// Returns a responsive font size based on screen size
  static double fontSize(
    BuildContext context, {
    required double base,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return value<double>(
      context: context,
      mobile: base,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );
  }

  /// Returns a responsive icon size based on screen size
  static double iconSize(BuildContext context) {
    return value<double>(
      context: context,
      mobile: 24,
      tablet: 28,
      desktop: 32,
      largeDesktop: 36,
    );
  }

  /// Returns a responsive border radius based on screen size
  static double borderRadius(BuildContext context) {
    return value<double>(
      context: context,
      mobile: 8,
      tablet: 12,
      desktop: 16,
      largeDesktop: 20,
    );
  }

  /// Returns a responsive width percentage based on screen size
  static double widthPercent(
    BuildContext context, {
    required double percent,
    double? tabletPercent,
    double? desktopPercent,
    double? largeDesktopPercent,
  }) {
    final width = MediaQuery.of(context).size.width;
    final effectivePercent = value<double>(
      context: context,
      mobile: percent,
      tablet: tabletPercent,
      desktop: desktopPercent,
      largeDesktop: largeDesktopPercent,
    );

    return width * effectivePercent;
  }

  /// Returns a responsive height percentage based on screen size
  static double heightPercent(
    BuildContext context, {
    required double percent,
    double? tabletPercent,
    double? desktopPercent,
    double? largeDesktopPercent,
  }) {
    final height = MediaQuery.of(context).size.height;
    final effectivePercent = value<double>(
      context: context,
      mobile: percent,
      tablet: tabletPercent,
      desktop: desktopPercent,
      largeDesktop: largeDesktopPercent,
    );

    return height * effectivePercent;
  }
}

/// A widget that returns different layouts based on screen size
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context) mobileBuilder;
  final Widget Function(BuildContext context)? tabletBuilder;
  final Widget Function(BuildContext context)? desktopBuilder;
  final Widget Function(BuildContext context)? largeDesktopBuilder;

  const ResponsiveBuilder({
    super.key,
    required this.mobileBuilder,
    this.tabletBuilder,
    this.desktopBuilder,
    this.largeDesktopBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveLayout.isLargeDesktop(context) &&
        largeDesktopBuilder != null) {
      return largeDesktopBuilder!(context);
    } else if (ResponsiveLayout.isDesktop(context) && desktopBuilder != null) {
      return desktopBuilder!(context);
    } else if (ResponsiveLayout.isTablet(context) && tabletBuilder != null) {
      return tabletBuilder!(context);
    } else {
      return mobileBuilder(context);
    }
  }
}
