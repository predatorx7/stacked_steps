import 'package:flutter_test/flutter_test.dart';
import 'package:stacked_steps/stacked_steps.dart';

void main() {
  group('basic controller tests', () {
    late StackedStepsController<int, int> controller;

    setUp(() {
      final step = StepData<int, int>(
        builder: (context, _, __) {
          throw UnimplementedError();
        },
        completedBuilder: (context, value, stepValue) {
          throw UnimplementedError();
        },
      );
      controller = StackedStepsController<int, int>(
        initialValue: 0,
        steps: [
          step.copyWith(
            value: 1,
          ),
          step.copyWith(
            value: 2,
          ),
          step.copyWith(
            value: 3,
          ),
          step.copyWith(
            value: 4,
          ),
          step.copyWith(
            value: 5,
          ),
        ],
      );
    });

    test('value of fields', () {
      expect(controller.value.steps, hasLength(5));
      expect(controller.value.progress, hasLength(0));
      expect(controller.value.current.value, 1);
      expect(controller.value.previous, isNull);
      expect(controller.value.next?.value, 2);
    });

    test('navigate checker to index of a completed step', () {
      controller.changeSteps(controller.value.steps.sublist(0, 4));
      expect(controller.canGoBackAt(5), isFalse);
      expect(controller.canGoBackAt(4), isFalse);
      expect(controller.canGoBackAt(-1), isFalse);
      expect(controller.canGoBackAt(0), isFalse);
      expect(controller.canGoBackAt(3), isFalse);

      controller.goNext(0);
      controller.goNext(1);
      controller.goNext(2);

      expect(controller.canGoBackAt(5), isFalse);
      expect(controller.canGoBackAt(4), isFalse);
      expect(controller.canGoBackAt(-1), isFalse);
      expect(controller.canGoBackAt(0), isTrue);
      expect(controller.canGoBackAt(3), isFalse);
      expect(controller.value.currentIndex, 3);
    });

    test('navigate to next index', () {
      controller.changeSteps(controller.value.steps.sublist(0, 4));
      expect(controller.canGoNext(), isTrue);
      controller.goNext(0);
      expect(controller.canGoNext(), isTrue);
      controller.goNext(1);
      expect(controller.canGoNext(), isTrue);
      controller.goNext(2);
      expect(controller.canGoNext(), isFalse);
    });

    test('navigate backwards', () {
      expect(controller.goBack(), isFalse);
      controller.goNext(0);
      expect(controller.goBack(), isTrue);
      expect(controller.goBack(), isFalse);
    });
  });
}
