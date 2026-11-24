import 'package:flutter/material.dart';
import 'package:pdd_tests/features/training/domain/entities/catalog.dart';
import 'package:pdd_tests/features/training/domain/usecases/start_quiz.dart';
import 'package:pdd_tests/features/training/presentation/format.dart';
import 'package:pdd_tests/features/training/presentation/pages/ticket_numbers_page.dart';
import 'package:pdd_tests/features/training/presentation/widgets/topic_tile.dart';

class TicketTopicsPage extends StatelessWidget {
  const TicketTopicsPage({
    super.key,
    required this.topics,
    required this.startQuiz,
  });

  final List<TicketTopic> topics;
  final StartQuiz startQuiz;

  @override
  Widget build(BuildContext context) {
    final sections = <(TicketSection, String)>[
      (TicketSection.themes, 'Темы Правил'),
      (TicketSection.subjects, 'Предметы'),
      (TicketSection.complex, 'Комплексные'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Билеты')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          for (final (section, label) in sections)
            if (topics.any((topic) => topic.section == section)) ...[
              SectionLabel(label),
              for (final topic in topics.where(
                (item) => item.section == section,
              ))
                TopicTile(
                  title: topic.title,
                  subtitle: _meta(topic),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => TicketNumbersPage(
                          topic: topic,
                          startQuiz: startQuiz,
                        ),
                      ),
                    );
                  },
                ),
            ],
        ],
      ),
    );
  }

  String _meta(TicketTopic topic) {
    final tickets = ruCount(topic.ticketCount, 'билет', 'билета', 'билетов');
    if (topic.subtitle.isEmpty) {
      return tickets;
    }
    return '${topic.subtitle} · $tickets';
  }
}
