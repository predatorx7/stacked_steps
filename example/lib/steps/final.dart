import 'package:flutter/material.dart';
import 'package:stacked_steps/stacked_steps.dart';

import '../data.dart';
import '../widgets/action_button.dart';
import '../widgets/card.dart';
import '../widgets/form.dart';

class StepFinal extends StatelessWidget {
  const StepFinal({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final StackedStepsController<FormData, StepDetails> controller;

  @override
  Widget build(BuildContext context) {
    return CurrentStepCard(
      controller: controller,
      child: StepFormBuilderWidget<FormData, StepDetails>(
        controller: controller,
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
                      title: Text('Your purchase has been completed.'),
                      subtitle: Text(
                        'The amount will be deposited in your account in a few minutes.',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      child: Material(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Text(
                                  'Credit purchase successful',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      ?.copyWith(
                                        fontWeight: FontWeight.w900,
                                      ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.done_outline,
                                    color: Colors.green,
                                    size: 100,
                                  )
                                ],
                              ),
                            ],
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
                  label: 'DONE',
                  onPressed: Navigator.of(context).pop,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
