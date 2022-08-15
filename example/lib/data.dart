import 'dart:math';

import 'package:flutter/material.dart';

class Option {
  final int id;
  final Color color;

  const Option(this.id, this.color);

  static List<Option> generate() {
    final colors = [
      ...Colors.primaries,
      ...Colors.accents,
    ];

    return List.generate(colors.length, (index) {
      return Option(
        index,
        colors[index],
      );
    });
  }
}

class EMIPlan {
  final double amount;
  final int months;
  final Color color;

  const EMIPlan(
    this.amount,
    this.months,
    this.color,
  );

  static List<EMIPlan> generate() {
    final colors = [
      ...Colors.primaries,
      ...Colors.accents,
    ];

    final rand = Random();
    return List.generate(colors.length, (index) {
      final amount = rand.nextInt(10000 - 3000) + 3000.0;

      return EMIPlan(
        amount,
        (colors.length - index) * 2,
        colors[index],
      );
    });
  }

  @override
  bool operator ==(Object other) {
    return other is EMIPlan && other.amount == amount && other.months == months;
  }

  @override
  int get hashCode => Object.hash(amount, months);
}

class BankInfo {
  final int id;
  final String name;
  final Color color;

  const BankInfo(
    this.id,
    this.name,
    this.color,
  );

  static List<BankInfo> generate() {
    final colors = [
      ...Colors.primaries,
      ...Colors.accents,
    ];

    final names = {
      'HDFC Bank',
      'SBI Bank',
      'IDFC Bank',
    };

    final rand = Random();
    return List.generate(names.length, (index) {
      final name = names.elementAt(index);
      final color = colors[rand.nextInt(colors.length)];
      final id = rand.nextInt(555555555) + 522222222;

      return BankInfo(
        id,
        name,
        color,
      );
    });
  }

  @override
  bool operator ==(Object other) {
    return other is BankInfo && other.id == id && other.name == name;
  }

  @override
  int get hashCode => Object.hash(id, name);
}

class StepDetails {
  final String title;
  final String hints;

  const StepDetails({
    required this.title,
    required this.hints,
  });

  @override
  bool operator ==(Object other) {
    return other is StepDetails && other.title == title && other.hints == hints;
  }

  @override
  int get hashCode => Object.hash(title, hints);
}

class FormData {
  final double? creditAmount;
  final EMIPlan? emi;
  final BankInfo? bankAccount;

  const FormData({
    this.creditAmount,
    this.emi,
    this.bankAccount,
  });

  FormData copyWith({
    Option? option,
    double? creditAmount,
    EMIPlan? emi,
    BankInfo? bankAccount,
  }) {
    return FormData(
      creditAmount: creditAmount ?? this.creditAmount,
      emi: emi ?? this.emi,
      bankAccount: bankAccount ?? this.bankAccount,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FormData &&
        other.creditAmount == creditAmount &&
        other.emi == emi &&
        other.bankAccount == bankAccount;
  }

  @override
  int get hashCode => Object.hash(creditAmount, emi, bankAccount);
}
