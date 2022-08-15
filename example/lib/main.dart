import 'package:example/steps/step_3.dart';
import 'package:flutter/material.dart';
import 'package:stacked_steps/stacked_steps.dart';

import 'data.dart';
import 'input.dart';
import 'steps/final.dart';
import 'steps/step_4.dart';
import 'steps/steps.dart';
import 'widgets/value.dart';

/// A very simple example to demonstrate a sample usage of the stacked steps library.
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stacked Views Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Option> options;

  @override
  void initState() {
    super.initState();
    options = Option.generate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a color'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
        padding: const EdgeInsets.all(8.0),
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];

          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                ExampleScreen.route(option),
              );
            },
            child: Container(
              color: option.color,
              child: const SizedBox.expand(),
            ),
          );
        },
      ),
    );
  }
}

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({
    Key? key,
    required this.option,
  }) : super(key: key);

  final Option option;

  static PageRoute route(Option option) {
    return MaterialPageRoute(
      builder: (context) {
        return ExampleScreen(option: option);
      },
    );
  }

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  late StackedStepsController<FormData, StepDetails> controller;

  @override
  void initState() {
    super.initState();

    controller = StackedStepsController(
      initialValue: const FormData(),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final darkColor = Color.lerp(widget.option.color, Colors.black, 0.5)!;

    final theme = CompletedTileThemeData.fallback().copyWith(
      light: widget.option.color,
      dark: darkColor,
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.cancel_rounded),
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          onPressed: Navigator.of(context).pop,
        ),
        title: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return Text(controller.value.current.value?.title ?? '');
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      backgroundColor: darkColor,
      body: StackedSteps(
        controller: controller,
        completedTileTheme: theme,
        steps: [
          StepData<FormData, StepDetails>(
            value: const StepDetails(
              title: 'Credit Amount',
              hints: '',
            ),
            builder: (context, oldValue, stepValue) {
              return StepCreditAmount(
                controller: controller,
              );
            },
            completedBuilder: (context, value, stepValue) {
              return TitleValue(
                title: stepValue?.title ?? '',
                value:
                    "\$ ${(CurrencyInputFormatter.formatter.format(value.creditAmount))}",
              );
            },
          ),
          StepData<FormData, StepDetails>(
            value: const StepDetails(
              title: 'EMI',
              hints: 'Proceed to EMI selection',
            ),
            builder: (context, oldValue, stepValue) {
              return StepEmiAmount(
                controller: controller,
              );
            },
            completedBuilder: (context, value, stepValue) {
              return Row(
                children: [
                  TitleValue(
                    title: stepValue?.title ?? '',
                    value:
                        "${CurrencyInputFormatter.currency} ${(value.emi?.amount ?? '0.0')} /mo",
                  ),
                  const Spacer(),
                  TitleValue(
                    title: 'duration',
                    value: '${value.emi?.months} months',
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              );
            },
          ),
          StepData<FormData, StepDetails>(
            value: const StepDetails(
              title: 'Bank Account',
              hints: 'Select your Bank Account',
            ),
            builder: (context, oldValue, stepValue) {
              return StepBankAccount(
                controller: controller,
              );
            },
            completedBuilder: (context, value, stepValue) {
              return TitleValue(
                title: stepValue?.title ?? '',
                value: "a/c ${value.bankAccount?.id}",
              );
            },
          ),
          StepData<FormData, StepDetails>(
            value: const StepDetails(
              title: 'KYC',
              hints: 'Tap for 1-click KYC',
            ),
            builder: (context, oldValue, stepValue) {
              return StepKYC(
                controller: controller,
              );
            },
            completedBuilder: (context, value, stepValue) {
              return TitleValue(
                title: stepValue?.title ?? '',
                value: "VERIFIED",
              );
            },
          ),
          StepData<FormData, StepDetails>(
            value: const StepDetails(
              title: 'Confirmation',
              hints: 'Proceed',
            ),
            builder: (context, oldValue, stepValue) {
              return StepFinal(
                controller: controller,
              );
            },
            completedBuilder: (context, value, stepValue) {
              return TitleValue(
                title: stepValue?.title ?? '',
                value: "VERIFIED",
              );
            },
          ),
        ],
      ),
    );
  }
}
