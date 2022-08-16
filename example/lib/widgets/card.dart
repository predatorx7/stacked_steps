import 'package:flutter/material.dart';
import 'package:stacked_steps/stacked_steps.dart';

class CurrentStepCard<T, V> extends StatelessWidget {
  const CurrentStepCard({
    Key? key,
    required this.controller,
    required this.child,
  }) : super(key: key);

  final StackedStepsController<T, V> controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tileTheme = StackedStepsTheme.of(context);
    final index = controller.value.currentIndex;
    final length = controller.value.progress.length + 2;

    final color = tileTheme.colorBuilder(
      context,
      index,
      length,
      tileTheme.light,
      tileTheme.dark,
    );

    return Material(
      color: color,
      elevation: tileTheme.elevation,
      borderRadius: tileTheme.borderRadius,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16,
          ),
          child: child,
        ),
      ),
    );
  }
}
