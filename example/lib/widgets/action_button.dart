import 'package:flutter/material.dart';
import 'package:stacked_steps/stacked_steps.dart';

class NextStepButton extends StatelessWidget {
  const NextStepButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  final String? label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tileTheme = StackedStepsTheme.of(context);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: tileTheme.borderRadius ?? BorderRadius.zero,
        ),
        minimumSize: const Size.fromHeight(kToolbarHeight),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label ?? 'PROCEED',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
