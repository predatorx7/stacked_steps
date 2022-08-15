import 'package:flutter/foundation.dart';

import '../../stacked_steps.dart';

part 'state.dart';

/// A controller for the progress through a succession of steps in a [StackedSteps] widget.
///
/// You can also use this same controller to builder your own custom stacked steps widget.
class StackedStepsController<T, V> extends ValueNotifier<ProgressState<T, V>> {
  /// Creats a new [StackedStepsController] with the given [initialValue].
  ///
  /// - The [initialValue] is the value which will be given to the first step.
  /// - Steps must have a length greater than 1. If empty, this will get steps from the [StackedSteps] widget.
  /// - [changeSteps] can be used to change the steps later.
  StackedStepsController({
    required T initialValue,
    List<StepData<T, V>> steps = const [],
  }) : super(ProgressState(initialValue, steps));

  bool canGoNext() => value.canGoNext();

  void changeSteps(List<StepData<T, V>> steps) {
    assert(steps.length >= 2);

    value = value.copyWith(steps: steps);
  }

  void goNext(T data) {
    final next = value.next;
    if (next != null) {
      value = value.copyWith(
        progress: [
          ...value.progress,
          value.current.copyAsCompleted(data),
        ],
      );
    } else {
      throw StateError('Next step is not available');
    }
  }

  bool canGoBackAt(int index) => value.canGoBackAt(index);

  bool goBackAt(int index) {
    if (canGoBackAt(index)) {
      value = value.copyWith(
        progress: value.progress.sublist(0, index),
      );
      return true;
    }
    return false;
  }

  bool goBack() {
    final previousIndex = value.previousIndex;
    if (previousIndex == null) return false;
    return goBackAt(previousIndex);
  }
}
