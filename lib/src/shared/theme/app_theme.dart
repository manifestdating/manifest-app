import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData theme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Color.fromARGB(255, 247, 247, 237),
    colorScheme: ColorScheme.fromSwatch(
            primarySwatch: createMaterialColor(Color(0xffD64045)))
        .copyWith(secondary: Color(0xff27213C)),
  );
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
