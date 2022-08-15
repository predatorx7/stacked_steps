import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A widget that animates its [child] when the state is initiated with
/// fade-in and scale-in transition for representing the entry of the UI built by [child].
class AnimatedAppearance extends StatefulWidget {
  const AnimatedAppearance({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  State<AnimatedAppearance> createState() => AnimatedAppearanceState();
}

class AnimatedAppearanceState extends State<AnimatedAppearance>
    with SingleTickerProviderStateMixin {
  static const _kFadeInDuration = Duration(milliseconds: 210);
  static const _kFadeOutDuration = Duration(milliseconds: 90);

  late AnimationController _controller;
  late Animation<double> animation;

  late Animation<double> _fadeIn;
  late Animation<double> _scaleIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _kFadeInDuration,
      reverseDuration: _kFadeOutDuration,
    );
    animation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.0,
        1.0,
        curve: Curves.ease,
      ),
    );

    startFadeInAnimation();
  }

  Future<void> startFadeInAnimation() async {
    _fadeIn = Tween(
      begin: 0.6,
      end: 1.0,
    ).animate(animation);
    _scaleIn = Tween(
      begin: 0.92,
      end: 1.0,
    ).animate(animation);

    try {
      await _controller.forward();
    } on TickerCanceled {
      // the animation got canceled, probably because it was disposed of
    }
  }

  Future<void> startFadeOutAnimation() async {
    _fadeIn = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(animation);
    _scaleIn = Tween(
      begin: 1.0,
      end: 0.92,
    ).animate(animation);

    try {
      _controller.reset();
      await _controller.forward().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because it was disposed of
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeIn,
          child: ScaleTransition(
            scale: _scaleIn,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
