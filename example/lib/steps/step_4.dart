import 'package:flutter/material.dart';
import 'package:stacked_steps/stacked_steps.dart';

import '../data.dart';
import '../widgets/card.dart';
import '../widgets/form.dart';

class StepKYC extends StatefulWidget {
  const StepKYC({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final StackedStepsController<FormData, StepDetails> controller;

  @override
  State<StepKYC> createState() => StepKYCState();
}

class StepKYCState extends State<StepKYC> {
  bool canProceed() {
    return widget.controller.value.canGoNext();
  }

  void onProceed(
    BuildContext context,
    ValueNotifier<FormData> o,
  ) async {
    final form = context.findAncestorStateOfType<FormState>();
    if (form?.validate() == true) {
      _isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));
      widget.controller.goNext(o.value);
      _isLoading.value = false;
    }
  }

  late ValueNotifier<bool> _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = ValueNotifier(false);
  }

  @override
  void dispose() {
    _isLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CurrentStepCard(
      controller: widget.controller,
      child: StepFormBuilderWidget<FormData, StepDetails>(
        controller: widget.controller,
        onInitForm: (value) {
          return value.copyWith();
        },
        builder: (
          context,
          ValueNotifier<FormData> o,
        ) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(60.0),
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: () => onProceed(context, o),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: SizedBox.expand(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AnimatedBuilder(
                                        animation: _isLoading,
                                        builder: (context, _) {
                                          if (_isLoading.value) {
                                            return const CircularProgressIndicator();
                                          }
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black26,
                                              border: Border.all(
                                                color: Colors.white54,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            height: 36,
                                            width: 36,
                                            child: const Icon(
                                              Icons.verified_user_outlined,
                                              size: 30,
                                              color: Colors.white70,
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 50.0),
                        child: Text(
                          'Complete your KYC',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.caption?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
