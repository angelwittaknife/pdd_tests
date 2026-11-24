import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdd_tests/app/pdd_app.dart';
import 'package:pdd_tests/features/training/domain/entities/catalog.dart';
import 'package:pdd_tests/features/training/domain/entities/quiz_session.dart';
import 'package:pdd_tests/features/training/presentation/theme/pdd_theme.dart';
import 'package:pdd_tests/features/training/presentation/theme/theme_mode_cubit.dart';

import 'support/fake_training_repository.dart';

void main() {
  testWidgets('theme button switches between light and dark', (tester) async {
    final store = _MemoryThemeModeStore();
    await tester.pumpWidget(
      PddApp(
        repository: FakeTrainingRepository(
          catalog: const Catalog(tickets: [], chapters: [], exams: []),
          session: const QuizSession(
            kind: QuizKind.ticket,
            title: 'Билет',
            allowedMistakes: null,
            questions: [],
          ),
        ),
        themeStore: store,
      ),
    );
    await tester.pumpAndSettle();

    final home = tester.element(find.text('Билеты по темам'));
    expect(Theme.of(home).brightness, Brightness.light);
    expect(Theme.of(home).extension<PddPalette>()!.card, PddPalette.light.card);

    await tester.tap(find.byTooltip('Тёмная тема'));
    await tester.pumpAndSettle();

    final dark = tester.element(find.text('Билеты по темам'));
    expect(Theme.of(dark).brightness, Brightness.dark);
    expect(Theme.of(dark).extension<PddPalette>()!.card, PddPalette.dark.card);
    expect(store.saved, ThemeMode.dark);

    await tester.tap(find.byTooltip('Светлая тема'));
    await tester.pumpAndSettle();

    final light = tester.element(find.text('Билеты по темам'));
    expect(Theme.of(light).brightness, Brightness.light);
    expect(store.saved, ThemeMode.light);
  });
}

final class _MemoryThemeModeStore implements ThemeModeStore {
  ThemeMode? saved;

  @override
  Future<ThemeMode?> read() async => saved;

  @override
  Future<void> write(ThemeMode mode) async {
    saved = mode;
  }
}
