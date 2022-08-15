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

/// Represents a single step in a series (list) of steps of a progress.
class StepData<T, V> {
  /// An optional value that is passed to the [builder], and [completedBuilder].
  final V? value;

  /// Called to obtain the widget that is displayed when this is the currently
  /// active step.
  ///
  /// This function is called whenever this widget is included in its parent's
  /// build when this becomes the active step.
  ///
  /// The value from the previous step is passed as the [oldValue] parameter which can
  /// also be [initialValue] from the controller when this is the first step.
  final ActiveStepWidgetBuilder<T, V> builder;

  /// Called to obtain the widget that is displayed when this step has been completed.
  ///
  /// This function is called whenever this widget is included in its parent's
  /// build when this becomes a completed step.
  ///
  /// The value obtained when the current step was completed is passed as the
  /// [value] parameter.
  final CompletedStepWidgetBuilder<T, V> completedBuilder;

  const StepData({
    this.value,
    required this.builder,
    required this.completedBuilder,
  });

  /// Creates a copy of this step with a [data] for representing this step as completed.
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

/// Represents a completed [StepData] with [data].
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
