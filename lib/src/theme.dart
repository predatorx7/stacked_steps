import 'package:flutter/material.dart';

typedef CompletedTileColorBuilder = Color Function(
  BuildContext context,
  int index,
  int length,
  Color startColor,
  Color endColor,
);

class CompletedTileThemeData {
  final Color light;
  final Color dark;
  final double elevation;
  final CompletedTileColorBuilder colorBuilder;
  final BorderRadiusGeometry? borderRadius;

  CompletedTileThemeData({
    required this.light,
    required this.dark,
    this.colorBuilder = _defaultColorBuilder,
    this.elevation = 2,
    this.borderRadius,
  });

  static Color _defaultColorBuilder(
    BuildContext context,
    int index,
    int length,
    Color light,
    Color dark,
  ) {
    return Color.lerp(
      light,
      dark,
      (length - index) / 10,
    )!;
  }

  factory CompletedTileThemeData.fallback() {
    return CompletedTileThemeData(
      light: Colors.grey,
      dark: Colors.grey.shade900,
      elevation: 2,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
    );
  }

  CompletedTileThemeData copyWith({
    Color? light,
    Color? dark,
    double? elevation,
    CompletedTileColorBuilder? colorBuilder,
    BorderRadiusGeometry? borderRadius,
  }) {
    return CompletedTileThemeData(
      light: light ?? this.light,
      dark: dark ?? this.dark,
      elevation: elevation ?? this.elevation,
      colorBuilder: colorBuilder ?? this.colorBuilder,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }
}

class CompletedTileTheme extends InheritedWidget {
  const CompletedTileTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  final CompletedTileThemeData data;

  static CompletedTileThemeData of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<CompletedTileTheme>();
    return result?.data ?? CompletedTileThemeData.fallback();
  }

  @override
  bool updateShouldNotify(CompletedTileTheme oldWidget) =>
      data != oldWidget.data;
}
