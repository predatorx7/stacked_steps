import 'package:flutter/material.dart';
import 'package:stacked_steps/stacked_steps.dart';

import '../data.dart';
import '../widgets/action_button.dart';
import '../widgets/card.dart';
import '../widgets/form.dart';

class StepBankAccount extends StatefulWidget {
  const StepBankAccount({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final StackedStepsController<FormData, StepDetails> controller;

  @override
  State<StepBankAccount> createState() => StepBankAccountState();
}

class StepBankAccountState extends State<StepBankAccount> {
  late List<BankInfo> banks;

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
    banks = BankInfo.generate();
  }

  @override
  void dispose() {
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
            bankAccount: banks.first,
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
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                        ),
                        itemCount: banks.length,
                        itemBuilder: (context, index) {
                          final account = banks[index];

                          return BankTile(
                            controller: o,
                            account: account,
                          );
                        },
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

class BankTile extends StatelessWidget {
  final BankInfo account;
  final ValueNotifier<FormData> controller;

  const BankTile({
    Key? key,
    required this.controller,
    required this.account,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final isSelected = controller.value.bankAccount == account;
        return ListTile(
          onTap: () {
            controller.value = controller.value.copyWith(
              bankAccount: account,
            );
          },
          leading: DecoratedBox(
            decoration: BoxDecoration(
              color: account.color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const SizedBox(
              height: 36,
              width: 36,
            ),
          ),
          title: Text(
            account.name,
            style: Theme.of(context).textTheme.caption?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          subtitle: Text(
            account.id.toString(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
          ),
          trailing: AnimatedContainer(
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
        );
      },
    );
  }
}
