import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdd_tests/features/training/domain/dataset_kind.dart';
import 'package:pdd_tests/features/training/presentation/cubit/mistake_box_cubit.dart';
import 'package:pdd_tests/features/training/domain/repositories/training_repository.dart';
import 'package:pdd_tests/features/training/domain/usecases/get_catalog.dart';
import 'package:pdd_tests/features/training/domain/usecases/start_quiz.dart';
import 'package:pdd_tests/features/training/presentation/pages/home_page.dart';
import 'package:pdd_tests/features/training/presentation/widgets/mode_card.dart';
import 'package:pdd_tests/features/training/presentation/widgets/pdd_frame.dart';
import 'package:pdd_tests/features/training/presentation/widgets/theme_brightness_button.dart';

typedef OpenDataset = Future<TrainingRepository> Function(DatasetKind kind);

class DatasetPage extends StatefulWidget {
  const DatasetPage({super.key, required this.openDataset});

  final OpenDataset openDataset;

  @override
  State<DatasetPage> createState() => _DatasetPageState();
}

class _DatasetPageState extends State<DatasetPage> {
  var _opening = false;
  String? _error;

  Future<void> _open(DatasetKind kind) async {
    if (_opening) {
      return;
    }
    setState(() {
      _opening = true;
      _error = null;
    });
    try {
      final repository = await widget.openDataset(kind);
      if (!mounted) {
        return;
      }
      await context.read<MistakeBoxCubit>().open(kind);
      if (!mounted) {
        return;
      }
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => HomePage(
            getCatalog: GetCatalog(repository),
            startQuiz: StartQuiz(repository),
            edition: kind.edition,
          ),
        ),
      );
    } on Object {
      if (mounted) {
        setState(() => _error = 'Не удалось открыть базу вопросов.');
      }
    } finally {
      if (mounted) {
        setState(() => _opening = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ПДД'),
        actions: const [ThemeBrightnessButton()],
      ),
      body: PddFrame(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Text(
              'Какую базу открыть?',
              style: Theme.of(context).textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.4),
            ),
            const SizedBox(height: 8),
            Text(
              'Дальше билеты, главы и зачёты читаются из выбранной базы.',
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                final adr = ModeCard(
                  icon: Icons.inventory_2_outlined,
                  title: 'ADr',
                  subtitle: 'Категория B. Билеты по темам, главы Правил и картинки вопросов.',
                  onTap: () => _open(DatasetKind.classic),
                );
                final np = ModeCard(
                  icon: Icons.menu_book_outlined,
                  title: 'НП',
                  subtitle: '2990 вопросов, пояснения и картинки вопросов.',
                  onTap: () => _open(DatasetKind.release22),
                );
                if (constraints.maxWidth < 680) {
                  return Column(children: [adr, np]);
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: adr),
                    const SizedBox(width: 12),
                    Expanded(child: np),
                  ],
                );
              },
            ),
            if (_opening)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(_error!, style: TextStyle(color: scheme.error)),
              ),
          ],
        ),
      ),
    );
  }
}
