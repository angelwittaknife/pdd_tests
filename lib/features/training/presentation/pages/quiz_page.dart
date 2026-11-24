import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdd_tests/features/training/domain/entities/question.dart';
import 'package:pdd_tests/features/training/domain/entities/quiz_session.dart';
import 'package:pdd_tests/features/training/domain/usecases/start_quiz.dart';
import 'package:pdd_tests/features/training/presentation/cubit/quiz_cubit.dart';
import 'package:pdd_tests/features/training/presentation/theme/pdd_theme.dart';
import 'package:pdd_tests/features/training/presentation/widgets/comment_view.dart';
import 'package:pdd_tests/features/training/presentation/widgets/zoomable_asset_image.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key, required this.startQuiz, required this.request});

  final StartQuiz startQuiz;
  final QuizRequest request;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuizCubit(startQuiz)..load(request),
      child: const _QuizView(),
    );
  }
}

class _QuizView extends StatelessWidget {
  const _QuizView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizCubit, QuizState>(
      builder: (context, state) {
        final title = switch (state) {
          QuizInProgress(:final session) => session.title,
          _ => 'Вопрос',
        };
        return Scaffold(
          appBar: AppBar(title: Text(title, overflow: TextOverflow.ellipsis)),
          body: switch (state) {
            QuizLoading() => const Center(child: CircularProgressIndicator()),
            QuizLoadFailure(:final message) => _LoadFailure(message: message),
            QuizInProgress() when state.showingResult => _Result(state: state),
            QuizInProgress() => _QuestionStep(state: state),
          },
        );
      },
    );
  }
}

class _LoadFailure extends StatelessWidget {
  const _LoadFailure({required this.message});

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
              onPressed: () => context.read<QuizCubit>().retry(),
              child: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionStep extends StatelessWidget {
  const _QuestionStep({required this.state});

  final QuizInProgress state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuizCubit>();
    final questions = state.session.questions;
    final question = state.current;
    final selectedId = state.selectedAnswerIds[question.id];
    final revealed = selectedId != null;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Row(
            children: [
              Text(
                'Вопрос ${state.index + 1} из ${questions.length}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const Spacer(),
              Text(
                'Верно ${state.correctCount}',
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
        if (questions.length <= 20)
          SizedBox(
            height: 32,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: questions.length,
              separatorBuilder: (context, index) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                return _ProgressChip(
                  number: index + 1,
                  current: index == state.index,
                  correct:
                      state.selectedAnswerIds.containsKey(questions[index].id)
                      ? state.answeredCorrectly(questions[index])
                      : null,
                  onTap: () => cubit.openQuestion(index),
                );
              },
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: LinearProgressIndicator(
              value: state.selectedAnswerIds.length / questions.length,
              minHeight: 6,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            children: [
              if (question.imageAsset != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ZoomableAssetImage(assetPath: question.imageAsset!),
                ),
                const SizedBox(height: 16),
              ],
              Text(
                question.text,
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(height: 1.35, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              for (var i = 0; i < question.answers.length; i++)
                _AnswerTile(
                  number: i + 1,
                  answer: question.answers[i],
                  revealed: revealed,
                  selected: selectedId == question.answers[i].id,
                  onTap: () => cubit.selectAnswer(question.answers[i].id),
                ),
              if (revealed && question.comment.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Пояснение',
                  style: Theme.of(context).textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                CommentView(pieces: question.comment),
              ],
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: [
                if (state.index > 0)
                  TextButton(
                    onPressed: cubit.previous,
                    child: const Text('Назад'),
                  ),
                const Spacer(),
                if (!revealed)
                  Text(
                    'Выберите ответ',
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: scheme.onSurfaceVariant),
                  )
                else
                  FilledButton(
                    onPressed: cubit.next,
                    child: Text(
                      state.index == questions.length - 1
                          ? 'Результат'
                          : 'Дальше',
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressChip extends StatelessWidget {
  const _ProgressChip({
    required this.number,
    required this.current,
    required this.correct,
    required this.onTap,
  });

  final int number;
  final bool current;
  final bool? correct;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final Color fill;
    final Color foreground;
    if (correct == true) {
      fill = PddColors.correct;
      foreground = Colors.white;
    } else if (correct == false) {
      fill = PddColors.wrong;
      foreground = Colors.white;
    } else {
      fill = scheme.surface;
      foreground = scheme.onSurface;
    }

    return Material(
      color: fill,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: current ? scheme.primary : scheme.outlineVariant,
          width: current ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: SizedBox(
          width: 32,
          child: Center(
            child: Text(
              '$number',
              style: TextStyle(
                color: foreground,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnswerTile extends StatelessWidget {
  const _AnswerTile({
    required this.number,
    required this.answer,
    required this.revealed,
    required this.selected,
    required this.onTap,
  });

  final int number;
  final AnswerOption answer;
  final bool revealed;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final showCorrect = revealed && answer.isCorrect;
    final showWrong = revealed && selected && !answer.isCorrect;

    final Color fill;
    final Color border;
    final Color badgeFill;
    final Color badgeText;
    if (showCorrect) {
      fill = PddColors.correctFill;
      border = PddColors.correct;
      badgeFill = PddColors.correct;
      badgeText = Colors.white;
    } else if (showWrong) {
      fill = PddColors.wrongFill;
      border = PddColors.wrong;
      badgeFill = PddColors.wrong;
      badgeText = Colors.white;
    } else {
      fill = scheme.surface;
      border = scheme.outlineVariant;
      badgeFill = scheme.surfaceContainerHighest;
      badgeText = scheme.onSurface;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: fill,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: border,
            width: showCorrect || showWrong ? 2 : 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: revealed ? null : onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: badgeFill,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$number',
                    style: TextStyle(
                      color: badgeText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      answer.text,
                      style: const TextStyle(height: 1.35),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Result extends StatelessWidget {
  const _Result({required this.state});

  final QuizInProgress state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuizCubit>();
    final total = state.session.questions.length;
    final correct = state.correctCount;
    final mistakes = total - correct;
    final allowed = state.session.allowedMistakes;
    final passed = allowed != null && mistakes <= allowed;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Column(
                    children: [
                      Text(
                        '$correct / $total',
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'верных ответов',
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                      if (allowed != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: passed
                                ? PddColors.correctFill
                                : PddColors.wrongFill,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            passed ? 'Зачёт сдан' : 'Зачёт не сдан',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: passed
                                  ? PddColors.correct
                                  : PddColors.wrong,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ошибок: $mistakes. Допуск: $allowed.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SliverList.builder(
                itemCount: state.session.questions.length,
                itemBuilder: (context, index) {
                  final question = state.session.questions[index];
                  final correctAnswer = state.answeredCorrectly(question);
                  return ListTile(
                    leading: Icon(
                      correctAnswer ? Icons.check_circle : Icons.cancel,
                      color: correctAnswer
                          ? PddColors.correct
                          : PddColors.wrong,
                    ),
                    title: Text(
                      question.text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => cubit.openQuestion(index),
                  );
                },
              ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: cubit.reviewMistakes,
                    child: const Text('Разобрать'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Закрыть'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
