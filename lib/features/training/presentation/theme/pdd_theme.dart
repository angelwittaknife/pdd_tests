import 'package:flutter/material.dart';

final class PddPalette extends ThemeExtension<PddPalette> {
  const PddPalette({
    required this.correct,
    required this.onCorrect,
    required this.correctFill,
    required this.wrong,
    required this.onWrong,
    required this.wrongFill,
    required this.imageBackdrop,
    required this.card,
  });

  final Color correct;
  final Color onCorrect;
  final Color correctFill;
  final Color wrong;
  final Color onWrong;
  final Color wrongFill;
  final Color imageBackdrop;
  final Color card;

  static const light = PddPalette(
    correct: Color(0xFF157A3A),
    onCorrect: Color(0xFFFFFFFF),
    correctFill: Color(0xFFE4F5EA),
    wrong: Color(0xFFC5362B),
    onWrong: Color(0xFFFFFFFF),
    wrongFill: Color(0xFFFDECEA),
    imageBackdrop: Color(0xFFE6EDF4),
    card: Color(0xFFFFFFFF),
  );

  static const dark = PddPalette(
    correct: Color(0xFF8ED4A8),
    onCorrect: Color(0xFF062014),
    correctFill: Color(0xFF163226),
    wrong: Color(0xFFF0A8A4),
    onWrong: Color(0xFF2A0C0A),
    wrongFill: Color(0xFF3A1E1C),
    imageBackdrop: Color(0xFF0E1318),
    card: Color(0xFF1E242C),
  );

  @override
  PddPalette copyWith({
    Color? correct,
    Color? onCorrect,
    Color? correctFill,
    Color? wrong,
    Color? onWrong,
    Color? wrongFill,
    Color? imageBackdrop,
    Color? card,
  }) {
    return PddPalette(
      correct: correct ?? this.correct,
      onCorrect: onCorrect ?? this.onCorrect,
      correctFill: correctFill ?? this.correctFill,
      wrong: wrong ?? this.wrong,
      onWrong: onWrong ?? this.onWrong,
      wrongFill: wrongFill ?? this.wrongFill,
      imageBackdrop: imageBackdrop ?? this.imageBackdrop,
      card: card ?? this.card,
    );
  }

  @override
  PddPalette lerp(PddPalette? other, double t) {
    if (other is! PddPalette) {
      return this;
    }
    return PddPalette(
      correct: Color.lerp(correct, other.correct, t)!,
      onCorrect: Color.lerp(onCorrect, other.onCorrect, t)!,
      correctFill: Color.lerp(correctFill, other.correctFill, t)!,
      wrong: Color.lerp(wrong, other.wrong, t)!,
      onWrong: Color.lerp(onWrong, other.onWrong, t)!,
      wrongFill: Color.lerp(wrongFill, other.wrongFill, t)!,
      imageBackdrop: Color.lerp(imageBackdrop, other.imageBackdrop, t)!,
      card: Color.lerp(card, other.card, t)!,
    );
  }
}

extension PddPaletteContext on BuildContext {
  PddPalette get pdd {
    final theme = Theme.of(this);
    return theme.extension<PddPalette>() ??
        (theme.brightness == Brightness.dark
            ? PddPalette.dark
            : PddPalette.light);
  }
}

ThemeData buildPddTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final scheme =
      ColorScheme.fromSeed(
        seedColor: dark ? const Color(0xFF8EB6F2) : const Color(0xFF1B4F9C),
        brightness: brightness,
        dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
      ).copyWith(
        surface: dark ? const Color(0xFF12151A) : const Color(0xFFF3F5F8),
        onSurface: dark ? const Color(0xFFE7EBF0) : const Color(0xFF1C2128),
        onSurfaceVariant: dark
            ? const Color(0xFFAEB6C0)
            : const Color(0xFF5E6872),
        outline: dark ? const Color(0xFF3E4752) : const Color(0xFFC5CED6),
        outlineVariant: dark
            ? const Color(0xFF2C343E)
            : const Color(0xFFDDE3EA),
        surfaceContainerLowest: dark
            ? const Color(0xFF0E1116)
            : const Color(0xFFFFFFFF),
        surfaceContainerLow: dark
            ? const Color(0xFF181C22)
            : const Color(0xFFF7F8FA),
        surfaceContainer: dark
            ? const Color(0xFF1E242C)
            : const Color(0xFFFFFFFF),
        surfaceContainerHigh: dark
            ? const Color(0xFF283039)
            : const Color(0xFFE7EBF0),
        surfaceContainerHighest: dark
            ? const Color(0xFF333B46)
            : const Color(0xFFDDE3EA),
      );
  const buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
  );
  const buttonText = TextStyle(fontSize: 15, fontWeight: FontWeight.w700);

  return ThemeData(
    colorScheme: scheme,
    brightness: brightness,
    useMaterial3: true,
    scaffoldBackgroundColor: scheme.surface,
    extensions: [dark ? PddPalette.dark : PddPalette.light],
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: scheme.onSurface,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(128, 48),
        shape: buttonShape,
        textStyle: buttonText,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(128, 48),
        shape: buttonShape,
        side: BorderSide(color: scheme.outline),
        foregroundColor: scheme.onSurface,
        textStyle: buttonText,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(64, 48),
        shape: buttonShape,
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: scheme.onSurfaceVariant),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: scheme.primary,
      thumbColor: scheme.primary,
      overlayColor: scheme.primary.withValues(alpha: 0.12),
    ),
    dividerTheme: DividerThemeData(
      color: scheme.outlineVariant,
      space: 1,
      thickness: 1,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: scheme.primary),
  );
}
