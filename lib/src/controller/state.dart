part of 'controller.dart';

class ProgressState<T, V> {
  final T initialValue;
  final List<StepData<T, V>> steps;
  final List<CompletedStep<T, V>> progress;

  ProgressState(
    this.initialValue,
    this.steps,
  ) : progress = const [];

  const ProgressState.raw(
    this.initialValue,
    this.steps,
    this.progress,
  );

  ProgressState<T, V> copyWith({
    T? initialValue,
    List<StepData<T, V>>? steps,
    List<CompletedStep<T, V>>? progress,
  }) {
    return ProgressState<T, V>.raw(
      initialValue ?? this.initialValue,
      steps ?? this.steps,
      progress != null ? List.unmodifiable(progress) : this.progress,
    );
  }

  bool get isLastStep {
    return progress.length + 1 >= steps.length;
  }

  int get currentIndex {
    return progress.length;
  }

  StepData<T, V> get current {
    return steps[currentIndex];
  }

  int? get previousIndex {
    if (progress.isEmpty) return null;
    return progress.length - 1;
  }

  CompletedStep<T, V>? get previous {
    final i = previousIndex;
    if (i == null) return null;
    return progress[i];
  }

  CompletedStep<T, V>? get last => previous;

  T get latestValue {
    final prev = previous;
    if (prev == null) return initialValue;
    return prev.data;
  }

  int? get nextIndex {
    if (isLastStep) {
      return null;
    }
    return progress.length + 1;
  }

  StepData<T, V>? get next {
    final i = nextIndex;
    if (i == null) return null;
    return steps[i];
  }

  bool canGoBackAt(int index) {
    final p = progress;
    if (p.isNotEmpty) {
      final l = p.length;
      return index >= 0 && index < l;
    }
    return false;
  }

  bool canGoNext() {
    return nextIndex != null;
  }

  @override
  bool operator ==(Object other) {
    return other is ProgressState<T, V> &&
        other.steps == steps &&
        other.progress == progress;
  }

  @override
  int get hashCode => Object.hash(current, steps, progress);
}
