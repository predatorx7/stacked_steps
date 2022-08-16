import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  static final formatter = NumberFormat('##,##,##,##', 'en_IN');
  static const currency = '₹';

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    int value = int.tryParse(newValue.text.replaceAll(r'[^0-9]', '')) ?? 0;

    String newText = formatter.format(value).replaceAll(
          formatter.currencySymbol,
          '',
        );

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
