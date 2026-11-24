import 'package:flutter/material.dart';
import 'package:pdd_tests/features/training/domain/entities/catalog.dart';
import 'package:pdd_tests/features/training/domain/entities/quiz_session.dart';
import 'package:pdd_tests/features/training/domain/exam_rules.dart';
import 'package:pdd_tests/features/training/domain/usecases/start_quiz.dart';
import 'package:pdd_tests/features/training/presentation/format.dart';
import 'package:pdd_tests/features/training/presentation/pages/exam_setup_page.dart';
import 'package:pdd_tests/features/training/presentation/pages/quiz_page.dart';
import 'package:pdd_tests/features/training/presentation/widgets/topic_tile.dart';

class ExamTopicsPage extends StatefulWidget {
  const ExamTopicsPage({
    super.key,
    required this.topics,
    required this.startQuiz,
  });

  final List<ExamTopic> topics;
  final StartQuiz startQuiz;

  @override
  State<ExamTopicsPage> createState() => _ExamTopicsPageState();
}

class _ExamTopicsPageState extends State<ExamTopicsPage> {
  int _tickets = ExamRules.defaultTickets;
  int _mistakes = ExamRules.defaultMistakes;

  Future<void> _open(ExamTopic topic) async {
    final choice = await Navigator.of(context).push<ExamChoice>(
      MaterialPageRoute(
        builder: (_) => ExamSetupPage(
          topic: topic,
          initialTickets: _tickets,
          initialMistakes: _mistakes,
        ),
      ),
    );
    if (!mounted || choice == null) {
      return;
    }
    setState(() {
      _tickets = choice.tickets;
      _mistakes = choice.mistakes;
    });
    final title = topic.section == TicketSection.complex
        ? topic.title
        : 'Зачёт · ${topic.title}';
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => QuizPage(
          startQuiz: widget.startQuiz,
          request: ExamQuizRequest(
            catTicketId: topic.catTicketId,
            title: title,
            ticketCount: choice.tickets,
            allowedMistakes: choice.mistakes,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sections = <(TicketSection, String)>[
      (TicketSection.themes, 'Темы Правил'),
      (TicketSection.subjects, 'Предметы'),
      (TicketSection.complex, 'По всем предметам'),
    ];
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Зачёты')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(
              'Сейчас ${ruCount(_tickets, 'билет', 'билета', 'билетов')}, '
              '${examAllowance(_mistakes)}. '
              'Откройте тему, чтобы изменить и начать.',
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: scheme.onSurfaceVariant, height: 1.35),
            ),
          ),
          for (final (section, label) in sections)
            if (widget.topics.any((topic) => topic.section == section)) ...[
              SectionLabel(label),
              for (final topic in widget.topics.where(
                (item) => item.section == section,
              ))
                TopicTile(
                  title: topic.title,
                  subtitle: _meta(topic),
                  onTap: () => _open(topic),
                ),
            ],
        ],
      ),
    );
  }

  String _meta(ExamTopic topic) {
    final tickets = ruCount(topic.ticketCount, 'билет', 'билета', 'билетов');
    if (topic.subtitle.isEmpty) {
      return tickets;
    }
    return '${topic.subtitle} · $tickets';
  }
}
