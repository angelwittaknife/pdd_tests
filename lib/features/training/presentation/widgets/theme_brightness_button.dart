import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdd_tests/features/training/presentation/theme/theme_mode_cubit.dart';

class ThemeBrightnessButton extends StatelessWidget {
  const ThemeBrightnessButton({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return IconButton(
      tooltip: dark ? 'Светлая тема' : 'Тёмная тема',
      onPressed: () => context.read<ThemeModeCubit>().toggle(),
      icon: Icon(
        dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
