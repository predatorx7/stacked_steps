import 'package:flutter/material.dart';
import 'package:stacked_steps/stacked_steps.dart';

import '../data.dart';
import '../input.dart';
import '../widgets/action_button.dart';
import '../widgets/card.dart';
import '../widgets/form.dart';

class StepEmiAmount extends StatefulWidget {
  const StepEmiAmount({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final StackedStepsController<FormData, StepDetails> controller;

  @override
  State<StepEmiAmount> createState() => StepEmiAmountState();
}

class StepEmiAmountState extends State<StepEmiAmount> {
  late PageController controller;
  late List<EMIPlan> plans;

  bool canProceed() {
    return widget.controller.value.canGoNext();
  }

  void onProceed(
    BuildContext context,
    ValueNotifier<FormData> o,
  ) {
    final form = context.findAncestorStateOfType<FormState>();
    if (form?.validate() == true) {
      widget.controller.goNext(o.value);
    }
  }

  @override
  void initState() {
    super.initState();
    plans = EMIPlan.generate();
    controller = PageController(
      viewportFraction: 1 / 2.3,
    );
  }

  Size? size;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newSize = MediaQuery.of(context).size;
    if (size?.width != newSize.width) {
      final lastPage = controller.hasClients ? controller.page : null;
      controller.dispose();
      controller = PageController(
        initialPage: lastPage?.round() ?? controller.initialPage,
        viewportFraction: ((1 / 2.3) * 570) / newSize.width,
      );
    }
    size = newSize;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CurrentStepCard(
      controller: widget.controller,
      child: StepFormBuilderWidget<FormData, StepDetails>(
        controller: widget.controller,
        onInitForm: (value) {
          return value.copyWith(
            emi: plans.first,
          );
        },
        builder: (
          context,
          ValueNotifier<FormData> o,
        ) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const ListTile(
                      title: Text('How do you wish to repay?'),
                      subtitle: Text(
                        'Choose one of our recommended plan',
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 16.0,
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 216,
                          ),
                          child: PageView.builder(
                            itemCount: plans.length,
                            controller: controller,
                            padEnds: false,
                            clipBehavior: Clip.none,
                            itemBuilder: (context, index) {
                              final plan = plans[index];

                              return PlanCard(
                                controller: o,
                                plan: plan,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: NextStepButton(
                  label: widget.controller.value.next?.value?.hints,
                  onPressed: () => onProceed(context, o),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final EMIPlan plan;
  final ValueNotifier<FormData> controller;

  const PlanCard({
    Key? key,
    required this.controller,
    required this.plan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints.tightFor(
                height: 200,
                width: 200,
              ),
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, _) {
                  final isSelected = controller.value.emi == plan;
                  return Material(
                    elevation: isSelected ? 4.0 : 0.0,
                    color: plan.color,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () {
                        controller.value = controller.value.copyWith(
                          emi: plan,
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.ease,
                                    decoration: isSelected
                                        ? const BoxDecoration(
                                            color: Colors.black26,
                                            shape: BoxShape.circle,
                                          )
                                        : BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white54,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                    height: 30,
                                    width: 30,
                                    child: Center(
                                      child: isSelected
                                          ? const Icon(
                                              Icons.check_rounded,
                                              color: Colors.white70,
                                            )
                                          : const SizedBox(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: CurrencyInputFormatter.currency,
                                  ),
                                  TextSpan(
                                    text: CurrencyInputFormatter.formatter
                                        .format(plan.amount),
                                  ),
                                  TextSpan(
                                    text: ' /mo',
                                    style: Theme.of(context)
                                        .textTheme
                                        .overline
                                        ?.copyWith(
                                          color: Colors.white54,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  TextSpan(
                                    text: '\nfor ${plan.months} months',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.start,
                              style:
                                  Theme.of(context).textTheme.caption?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
