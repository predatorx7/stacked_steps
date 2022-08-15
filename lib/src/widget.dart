import 'package:flutter/material.dart';
import 'package:stacked_steps/src/stage.dart';

import 'animation.dart';
import 'controller/controller.dart';
import 'theme.dart';

class StepBuilderData<T, V> {
  final int index;
  final CompletedStep<T, V> step;
  final Widget stepChild;

  const StepBuilderData(this.index, this.step, this.stepChild);
}

typedef StepWidgetBuilder<T, V> = Widget Function(
  BuildContext context,
  StepBuilderData<T, V> data,
  Widget child,
);

/// A widget that showcases progress through a succession of steps where successive
/// steps are stacked over previous steps.
class StackedSteps<T, V> extends StatefulWidget {
  final StackedStepsController<T, V> controller;

  /// The steps to use in the progress in order of entry i.e the first item is the first step and
  /// the last item is the last or final step.
  ///
  /// Atleast 2 steps must be provided where each step
  /// will get the value from previous completed step from [StackedStepsController.value.latestValue].
  final List<StepData<T, V>>? steps;

  /// A builder that constructs all the completed steps.
  ///
  /// If null, the default collapsed tile builder is used.
  final StepWidgetBuilder<T, V>? completedStepBuilder;
  final CompletedTileThemeData? completedTileTheme;

  const StackedSteps({
    Key? key,
    required this.controller,
    this.steps,
    this.completedStepBuilder,
    this.completedTileTheme,
  }) : super(key: key);

  @override
  State<StackedSteps<T, V>> createState() => _StackedStepsState<T, V>();
}

class _StackedStepsState<T, V> extends State<StackedSteps<T, V>> {
  StackedStepsController<T, V> get controller => widget.controller;

  List<StepData<T, V>>? resolveSteps() {
    final widgetSteps = widget.steps;
    if (widgetSteps != null) {
      return widgetSteps;
    } else if (controller.value.steps.length < 2) {
      throw FlutterError(
        'At least two steps are required. Provide steps either in the `StackedSteps` widget or in the `StackedStepsController`',
      );
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    if (widget.steps != null) {
      final steps = resolveSteps();
      if (steps != null) {
        controller.changeSteps(steps);
      }
    }
  }

  @override
  void didUpdateWidget(covariant StackedSteps<T, V> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.steps != oldWidget.steps) {
      final steps = resolveSteps();
      if (steps != null) {
        Future.microtask(() {
          controller.changeSteps(steps);
        });
      }
    }
  }

  Future<bool> onBack() {
    controller.goBack();
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    Widget child = AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final current = controller.value.current;
        final next = controller.value.next;
        final lastValue = controller.value.latestValue;
        final progress = controller.value.progress;

        Widget activeStage = AnimatedAppearance(
          child: current.builder(
            context,
            lastValue,
            current.value,
          ),
        );

        if (next != null) {
          activeStage = WillPopScope(
            onWillPop: onBack,
            child: activeStage,
          );

          if (progress.isNotEmpty) {
            Widget completedStepsChild = activeStage;

            for (var i = progress.length - 1; i >= 0; i--) {
              final step = progress[i];

              completedStepsChild = CompletedTile<T, V>(
                index: i,
                length: progress.length,
                onPressed: () {
                  final didGoBack = controller.goBackAt(i);
                  assert(didGoBack);
                },
                step: step,
                builder: widget.completedStepBuilder,
                nextChild: completedStepsChild,
              );
            }

            return completedStepsChild;
          }
        }

        return activeStage;
      },
    );

    final theme = widget.completedTileTheme;
    if (theme != null) {
      child = CompletedTileTheme(
        data: theme,
        child: child,
      );
    }

    return child;
  }
}

class CompletedTile<T, V> extends StatelessWidget {
  const CompletedTile({
    Key? key,
    required this.index,
    required this.length,
    required this.onPressed,
    required this.step,
    required this.nextChild,
    this.builder,
  }) : super(key: key);

  final int index;
  final int length;
  final VoidCallback onPressed;
  final CompletedStep<T, V> step;
  final StepWidgetBuilder<T, V>? builder;
  final Widget nextChild;

  @override
  Widget build(BuildContext context) {
    Widget stepChild = step.completedBuilder(
      context,
      step.data,
      step.value,
    );

    final builder = this.builder;

    if (builder != null) {
      return builder(
        context,
        StepBuilderData<T, V>(
          index,
          step,
          stepChild,
        ),
        nextChild,
      );
    }

    final theme = CompletedTileTheme.of(context);

    final color = theme.colorBuilder(
      context,
      index,
      length,
      theme.light,
      theme.dark,
    );

    return AnimatedAppearance(
      child: Material(
        color: color,
        elevation: theme.elevation,
        borderRadius: theme.borderRadius,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 0,
              child: Builder(builder: (context) {
                return GestureDetector(
                  onTap: () async {
                    final state = context
                        .findAncestorStateOfType<AnimatedAppearanceState>();
                    await state?.startFadeOutAnimation();
                    onPressed();
                  },
                  child: ListTile(
                    title: stepChild,
                    trailing: const Icon(Icons.arrow_drop_down_rounded),
                  ),
                );
              }),
            ),
            Expanded(
              child: nextChild,
            ),
          ],
        ),
      ),
    );
  }
}
