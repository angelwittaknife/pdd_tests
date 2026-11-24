import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdd_tests/features/training/domain/entities/catalog.dart';
import 'package:pdd_tests/features/training/domain/entities/quiz_session.dart';
import 'package:pdd_tests/features/training/domain/usecases/get_catalog.dart';
import 'package:pdd_tests/features/training/domain/usecases/start_quiz.dart';
import 'package:pdd_tests/features/training/presentation/cubit/catalog_cubit.dart';
import 'package:pdd_tests/features/training/presentation/cubit/mistake_box_cubit.dart';
import 'package:pdd_tests/features/training/presentation/format.dart';
import 'package:pdd_tests/features/training/presentation/pages/chapters_page.dart';
import 'package:pdd_tests/features/training/presentation/pages/exam_topics_page.dart';
import 'package:pdd_tests/features/training/presentation/pages/quiz_page.dart';
import 'package:pdd_tests/features/training/presentation/pages/ticket_topics_page.dart';
import 'package:pdd_tests/features/training/presentation/theme/pdd_theme.dart';
import 'package:pdd_tests/features/training/presentation/widgets/mode_card.dart';
import 'package:pdd_tests/features/training/presentation/widgets/pdd_frame.dart';
import 'package:pdd_tests/features/training/presentation/widgets/theme_brightness_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.getCatalog,
    required this.startQuiz,
    this.edition = 'Категория B · Беларусь',
  });

  final GetCatalog getCatalog;
  final StartQuiz startQuiz;
  final String edition;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CatalogCubit(getCatalog)..load(),
      child: _HomeView(startQuiz: startQuiz, edition: edition),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({required this.startQuiz, required this.edition});

  final StartQuiz startQuiz;
  final String edition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ПДД'),
        actions: const [ThemeBrightnessButton()],
      ),
      body: BlocBuilder<CatalogCubit, CatalogState>(
        builder: (context, state) {
          return switch (state) {
            CatalogLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            CatalogFailure(:final message) => _Failure(message: message),
            CatalogReady(:final catalog) => _Modes(
              catalog: catalog,
              startQuiz: startQuiz,
              edition: edition,
            ),
          };
        },
      ),
    );
  }
}

class _Modes extends StatelessWidget {
  const _Modes({
    required this.catalog,
    required this.startQuiz,
    required this.edition,
  });

  final Catalog catalog;
  final StartQuiz startQuiz;
  final String edition;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return PddFrame(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text(
            edition,
            style: Theme.of(context).textTheme.headlineMedium
                ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.4),
          ),
          const SizedBox(height: 4),
          Text(
            'Билеты, главы и зачёты',
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          ModeCard(
            icon: Icons.style_outlined,
            title: 'Билеты по темам',
            subtitle:
                'Готовые билеты по темам Правил, предметам и комплексные.',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => TicketTopicsPage(
                    topics: catalog.tickets,
                    startQuiz: startQuiz,
                  ),
                ),
              );
            },
          ),
          ModeCard(
            icon: Icons.menu_book_outlined,
            title: 'Вопросы по главам',
            subtitle: 'Все вопросы главы подряд, с картинкой и пояснением.',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => ChaptersPage(
                    topics: catalog.chapters,
                    startQuiz: startQuiz,
                  ),
                ),
              );
            },
          ),
          ModeCard(
            icon: Icons.fact_check_outlined,
            title: 'Зачёты по темам',
            subtitle: 'Случайные билеты из темы. Число билетов и допуск ошибок выбираются перед стартом.',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => ExamTopicsPage(
                    topics: catalog.exams,
                    startQuiz: startQuiz,
                  ),
                ),
              );
            },
          ),
          BlocBuilder<MistakeBoxCubit, List<int>>(
            builder: (context, questionIds) {
              final count = questionIds.length;
              final palette = context.pdd;
              return ModeCard(
                icon: Icons.inbox_outlined,
                title: 'Коробка ошибок',
                badge: count == 0 ? null : '$count',
                iconBackground: count == 0 ? null : palette.wrongFill,
                iconColor: count == 0 ? null : palette.wrong,
                subtitle: count == 0
                    ? 'Пока пусто. Неверный ответ из любого режима кладёт вопрос сюда.'
                    : '${ruCount(count, 'вопрос', 'вопроса', 'вопросов')}. Верный ответ убирает вопрос из коробки.',
                onTap: () {
                  final ids = List<int>.of(
                    context.read<MistakeBoxCubit>().state,
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ids.isEmpty
                          ? const _EmptyMistakeBoxPage()
                          : QuizPage(
                              startQuiz: startQuiz,
                              request: MistakeQuizRequest(questionIds: ids),
                            ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _EmptyMistakeBoxPage extends StatelessWidget {
  const _EmptyMistakeBoxPage();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Коробка ошибок'),
        actions: const [ThemeBrightnessButton()],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Сюда попадают вопросы, на которые вы ответили неверно.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(color: scheme.onSurfaceVariant, height: 1.4),
          ),
        ),
      ),
    );
  }
}

class _Failure extends StatelessWidget {
  const _Failure({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.read<CatalogCubit>().load(),
              child: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }
}
