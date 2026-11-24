import 'package:flutter/material.dart';
import 'package:pdd_tests/features/training/domain/entities/catalog.dart';
import 'package:pdd_tests/features/training/domain/entities/quiz_session.dart';
import 'package:pdd_tests/features/training/domain/usecases/start_quiz.dart';
import 'package:pdd_tests/features/training/presentation/pages/quiz_page.dart';
import 'package:pdd_tests/features/training/presentation/theme/pdd_theme.dart';
import 'package:pdd_tests/features/training/presentation/widgets/pdd_frame.dart';
import 'package:pdd_tests/features/training/presentation/widgets/theme_brightness_button.dart';

class TicketNumbersPage extends StatelessWidget {
  const TicketNumbersPage({
    super.key,
    required this.topic,
    required this.startQuiz,
  });

  final TicketTopic topic;
  final StartQuiz startQuiz;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(topic.title),
        actions: const [ThemeBrightnessButton()],
      ),
      body: PddFrame(
        child: GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 88,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: topic.ticketCount,
          itemBuilder: (context, index) {
            final number = index + 1;
            return Material(
              color: context.pdd.card,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: scheme.outlineVariant),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => QuizPage(
                        startQuiz: startQuiz,
                        request: TicketQuizRequest(
                          catTicketId: topic.catTicketId,
                          ticketNumber: number,
                          title: '${topic.title} · билет $number',
                        ),
                      ),
                    ),
                  );
                },
                child: Center(
                  child: Text(
                    '$number',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: scheme.primary,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
