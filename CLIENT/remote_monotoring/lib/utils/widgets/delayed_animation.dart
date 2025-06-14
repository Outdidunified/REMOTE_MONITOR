import 'package:flutter/material.dart';

/// A widget that animates its child with a delay
class DelayedAnimation extends StatefulWidget {
  /// The child to animate
  final Widget child;

  /// The delay before starting the animation
  final Duration delay;

  /// The duration of the animation
  final Duration duration;

  /// The animation curve
  final Curve curve;

  /// The builder function that builds the animated widget
  final Widget Function(BuildContext, double, Widget?) builder;

  const DelayedAnimation({
    Key? key,
    required this.child,
    required this.delay,
    required this.duration,
    this.curve = Curves.easeOut,
    required this.builder,
  }) : super(key: key);

  @override
  State<DelayedAnimation> createState() => _DelayedAnimationState();
}

class _DelayedAnimationState extends State<DelayedAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    // Start the animation after the delay
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder:
          (context, child) => widget.builder(context, _animation.value, child),
      child: widget.child,
    );
  }
}
