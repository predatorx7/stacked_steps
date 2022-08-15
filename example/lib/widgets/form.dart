import 'package:flutter/material.dart';
import 'package:stacked_steps/stacked_steps.dart';

typedef FormGetter<T> = T Function();
typedef FormUpdateCallback<T> = T Function(T data);
typedef FormUpdatorCallback<T> = void Function(FormUpdateCallback<T> update);
typedef StepBuilderCallback<T, V> = Widget Function(
  BuildContext context,
  ValueNotifier<T> value,
);

class StepFormBuilderWidget<T, V> extends StatefulWidget {
  const StepFormBuilderWidget({
    Key? key,
    this.onInitForm,
    required this.controller,
    required this.builder,
  }) : super(key: key);

  final FormUpdateCallback<T>? onInitForm;
  final StackedStepsController<T, V> controller;
  final StepBuilderCallback<T, V> builder;

  @override
  State<StepFormBuilderWidget<T, V>> createState() =>
      StepFormBuilderWidgetState<T, V>();
}

class StepFormBuilderWidgetState<T, V>
    extends State<StepFormBuilderWidget<T, V>> {
  late ValueNotifier<T> _dataNotifier;

  @override
  void initState() {
    super.initState();
    _dataNotifier = ValueNotifier(
      widget.onInitForm?.call(
            widget.controller.value.latestValue,
          ) ??
          widget.controller.value.latestValue,
    );
  }

  @override
  void dispose() {
    _dataNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Builder(
        builder: (context) {
          return widget.builder(
            context,
            _dataNotifier,
          );
        },
      ),
    );
  }
}
