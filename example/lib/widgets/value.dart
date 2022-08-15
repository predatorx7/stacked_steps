import 'package:flutter/material.dart';

class TitleValue extends StatelessWidget {
  const TitleValue({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: title,
            style: Theme.of(context).textTheme.caption,
          ),
          const TextSpan(
            text: '\n',
          ),
          TextSpan(
            text: value,
            style: Theme.of(context).textTheme.titleLarge?.merge(
                  const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
          ),
        ],
      ),
      textAlign: TextAlign.start,
      style: const TextStyle(
        color: Colors.white,
      ),
    );
  }
}
