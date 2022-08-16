import 'package:flutter/material.dart';

typedef CompletedTileColorBuilder = Color Function(
  BuildContext context,
  int index,
  int length,
  Color startColor,
  Color endColor,
);

class StackedStepsThemeData {
  final Color light;
  final Color dark;
  final Brightness? brightness;
  final double elevation;
  final CompletedTileColorBuilder colorBuilder;
  final BorderRadiusGeometry? borderRadius;

  StackedStepsThemeData({
    required this.light,
    required this.dark,
    this.colorBuilder = _defaultColorBuilder,
    this.brightness,
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

  factory StackedStepsThemeData.fallback() {
    return StackedStepsThemeData(
      light: Colors.grey,
      dark: Colors.grey.shade900,
      elevation: 2,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
    );
  }

  StackedStepsThemeData copyWith({
    Color? light,
    Color? dark,
    double? elevation,
    CompletedTileColorBuilder? colorBuilder,
    BorderRadiusGeometry? borderRadius,
    Brightness? brightness,
  }) {
    return StackedStepsThemeData(
      light: light ?? this.light,
      dark: dark ?? this.dark,
      brightness: brightness ?? this.brightness,
      elevation: elevation ?? this.elevation,
      colorBuilder: colorBuilder ?? this.colorBuilder,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }
}

class StackedStepsTheme extends InheritedWidget {
  const StackedStepsTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  final StackedStepsThemeData data;

  static StackedStepsThemeData of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<StackedStepsTheme>();
    return result?.data ?? StackedStepsThemeData.fallback();
  }

  @override
  bool updateShouldNotify(StackedStepsTheme oldWidget) =>
      data != oldWidget.data;
}
