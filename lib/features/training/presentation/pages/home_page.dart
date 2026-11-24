import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdd_tests/features/training/domain/entities/catalog.dart';
import 'package:pdd_tests/features/training/domain/usecases/get_catalog.dart';
import 'package:pdd_tests/features/training/domain/usecases/start_quiz.dart';
import 'package:pdd_tests/features/training/presentation/cubit/catalog_cubit.dart';
import 'package:pdd_tests/features/training/presentation/pages/chapters_page.dart';
import 'package:pdd_tests/features/training/presentation/pages/exam_topics_page.dart';
import 'package:pdd_tests/features/training/presentation/pages/ticket_topics_page.dart';
import 'package:pdd_tests/features/training/presentation/widgets/mode_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.getCatalog,
    required this.startQuiz,
  });

  final GetCatalog getCatalog;
  final StartQuiz startQuiz;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CatalogCubit(getCatalog)..load(),
      child: _HomeView(startQuiz: startQuiz),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({required this.startQuiz});

  final StartQuiz startQuiz;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ПДД')),
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
            ),
          };
        },
      ),
    );
  }
}

class _Modes extends StatelessWidget {
  const _Modes({required this.catalog, required this.startQuiz});

  final Catalog catalog;
  final StartQuiz startQuiz;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Text(
          'Категория B · Беларусь',
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: 16),
        ModeCard(
          icon: Icons.style_outlined,
          title: 'Билеты по темам',
          subtitle: 'Готовые билеты по темам Правил, предметам и комплексные.',
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
                builder: (_) =>
                    ExamTopicsPage(topics: catalog.exams, startQuiz: startQuiz),
              ),
            );
          },
        ),
      ],
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
