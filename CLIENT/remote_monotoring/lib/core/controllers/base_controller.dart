import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Base controller class that ensures proper disposal of resources
/// All controllers should extend this class to ensure consistent behavior
class BaseController extends GetxController {
  // List to track all disposable resources
  final List<dynamic> _disposables = [];

  // Flag to prevent duplicate disposal
  bool _isDisposed = false;

  /// Add a disposable resource to be automatically disposed when controller is closed
  void addDisposable(dynamic disposable) {
    _disposables.add(disposable);
  }

  /// Register a TextEditingController for automatic disposal
  TextEditingController registerTextController([String? initialText]) {
    final controller = TextEditingController(text: initialText);
    addDisposable(controller);
    return controller;
  }

  /// Register a ScrollController for automatic disposal
  ScrollController registerScrollController() {
    final controller = ScrollController();
    addDisposable(controller);
    return controller;
  }

  /// Register a FocusNode for automatic disposal
  FocusNode registerFocusNode() {
    final node = FocusNode();
    addDisposable(node);
    return node;
  }

  /// Register an AnimationController for automatic disposal
  AnimationController registerAnimationController({
    required TickerProvider vsync,
    required Duration duration,
    Duration? reverseDuration,
  }) {
    final controller = AnimationController(
      vsync: vsync,
      duration: duration,
      reverseDuration: reverseDuration,
    );
    addDisposable(controller);
    return controller;
  }

  /// Register a StreamSubscription for automatic disposal
  void registerSubscription(dynamic subscription) {
    addDisposable(subscription);
  }

  /// Register a Timer for automatic disposal
  void registerTimer(dynamic timer) {
    addDisposable(timer);
  }

  /// Dispose all registered resources
  void disposeAll() {
    if (_isDisposed) return;

    for (final disposable in _disposables) {
      try {
        if (disposable is TextEditingController) {
          disposable.dispose();
        } else if (disposable is ScrollController) {
          disposable.dispose();
        } else if (disposable is FocusNode) {
          disposable.dispose();
        } else if (disposable is AnimationController) {
          disposable.dispose();
        } else if (disposable is StreamSubscription) {
          disposable.cancel();
        } else if (disposable is Timer) {
          disposable.cancel();
        } else if (disposable != null && disposable.dispose is Function) {
          disposable.dispose();
        } else if (disposable != null && disposable.cancel is Function) {
          disposable.cancel();
        }
      } catch (e) {
        debugPrint('Error disposing resource: $e');
      }
    }

    _disposables.clear();
    _isDisposed = true;
  }

  @override
  void onClose() {
    disposeAll();
    super.onClose();
  }
}
