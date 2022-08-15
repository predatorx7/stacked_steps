import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:stacked_steps/stacked_steps.dart';

import '../data.dart';
import '../input.dart';
import '../widgets/action_button.dart';
import '../widgets/card.dart';
import '../widgets/form.dart';

class StepCreditAmount extends StatefulWidget {
  const StepCreditAmount({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final StackedStepsController<FormData, StepDetails> controller;

  @override
  State<StepCreditAmount> createState() => _StepCreditAmountState();
}

class _StepCreditAmountState extends State<StepCreditAmount> {
  late TextEditingController controller;

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
    controller = TextEditingController(
      text: CurrencyInputFormatter.formatter.format(1500000),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const currency = CurrencyInputFormatter.currency;

    return CurrentStepCard(
      controller: widget.controller,
      child: StepFormBuilderWidget<FormData, StepDetails>(
        controller: widget.controller,
        onInitForm: (data) {
          return data.copyWith(
            creditAmount: 1500000,
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
                      title: Text('How much do you need?'),
                      subtitle: Text(
                        'Set any amount you need upto $currency 50,00,000',
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
                                  'credit amount',
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
                                children: [
                                  SleekCircularSlider(
                                    initialValue: 1500000,
                                    min: 10000,
                                    max: 5000000,
                                    appearance: CircularSliderAppearance(
                                      size: 300,
                                      startAngle: 270,
                                      angleRange: 360,
                                      customColors: CustomSliderColors(
                                        progressBarColor: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                        trackColor: Colors.grey[200],
                                        dotColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        hideShadow: true,
                                        shadowColor: Colors.transparent,
                                      ),
                                      customWidths: CustomSliderWidths(
                                        progressBarWidth: 12,
                                        trackWidth: 12,
                                        handlerSize: 16,
                                      ),
                                    ),
                                    onChange: (double value) {
                                      final val = value.round();
                                      o.value = o.value.copyWith(
                                        creditAmount: val.toDouble(),
                                      );
                                      controller.text = CurrencyInputFormatter
                                          .formatter
                                          .format(value);
                                    },
                                    innerWidget: (value) {
                                      return Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0,
                                              vertical: 16.0,
                                            ),
                                            child: TextFormField(
                                              controller: controller,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                FilteringTextInputFormatter
                                                    .singleLineFormatter,
                                              ],
                                              keyboardType:
                                                  TextInputType.number,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: const InputDecoration(
                                                prefixText: currency,
                                                filled: false,
                                                constraints:
                                                    BoxConstraints.tightFor(
                                                  width: 150,
                                                ),
                                                prefixStyle: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  decoration:
                                                      TextDecoration.none,
                                                  decorationStyle:
                                                      TextDecorationStyle.solid,
                                                ),
                                              ),
                                              textAlign: TextAlign.center,
                                              onChanged: (val) {
                                                final value =
                                                    (double.tryParse(val))
                                                            ?.round() ??
                                                        5000;
                                                o.value = o.value.copyWith(
                                                  creditAmount:
                                                      value.toDouble(),
                                                );
                                                controller.text =
                                                    CurrencyInputFormatter
                                                        .formatter
                                                        .format(value);
                                              },
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationStyle:
                                                    TextDecorationStyle.dashed,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
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
