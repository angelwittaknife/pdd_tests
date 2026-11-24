import 'package:flutter/material.dart';

abstract final class PddColors {
  static const correct = Color(0xFF1B7F3A);
  static const correctFill = Color(0xFFE5F6EA);
  static const wrong = Color(0xFFC62828);
  static const wrongFill = Color(0xFFFDECEC);
  static const imageBackdrop = Color(0xFFE7EDF4);
  static const page = Color(0xFFF3F5F8);
}

ThemeData buildPddTheme() {
  const seed = Color(0xFF0D47A1);
  final scheme = ColorScheme.fromSeed(seedColor: seed);
  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    scaffoldBackgroundColor: PddColors.page,
    appBarTheme: AppBarTheme(
      backgroundColor: PddColors.page,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(128, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
