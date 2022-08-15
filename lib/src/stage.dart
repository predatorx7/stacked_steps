import 'package:flutter/widgets.dart';

typedef ActiveStepWidgetBuilder<T, V> = Widget Function(
  BuildContext context,
  T oldValue,
  V? stepValue,
);

typedef CompletedStepWidgetBuilder<T, V> = Widget Function(
  BuildContext context,
  T value,
  V? stepValue,
);

class StepData<T, V> {
  final V? value;
  final ActiveStepWidgetBuilder<T, V> builder;
  final CompletedStepWidgetBuilder<T, V> completedBuilder;

  const StepData({
    this.value,
    required this.builder,
    required this.completedBuilder,
  });

  CompletedStep<T, V> copyAsCompleted(T data) {
    return CompletedStep(
      data: data,
      value: value,
      builder: builder,
      completedBuilder: completedBuilder,
    );
  }

  StepData<T, V> copyWith({
    V? value,
    ActiveStepWidgetBuilder<T, V>? builder,
    CompletedStepWidgetBuilder<T, V>? completedBuilder,
  }) {
    return StepData(
      value: value ?? this.value,
      builder: builder ?? this.builder,
      completedBuilder: completedBuilder ?? this.completedBuilder,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CompletedStep<T, V> &&
        other.value == value &&
        other.builder == builder &&
        other.completedBuilder == completedBuilder;
  }

  @override
  int get hashCode => Object.hash(value, builder, completedBuilder);
}

class CompletedStep<T, V> extends StepData<T, V> {
  final T data;

  const CompletedStep({
    required this.data,
    super.value,
    required super.builder,
    required super.completedBuilder,
  });

  @override
  bool operator ==(Object other) {
    return other is CompletedStep<T, V> &&
        other.data == data &&
        other.value == value &&
        other.builder == builder &&
        other.completedBuilder == completedBuilder;
  }

  @override
  int get hashCode => Object.hash(data, value, builder, completedBuilder);
}
