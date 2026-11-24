import 'package:flutter/material.dart';
import 'package:pdd_tests/features/training/domain/entities/catalog.dart';
import 'package:pdd_tests/features/training/domain/entities/quiz_session.dart';
import 'package:pdd_tests/features/training/domain/usecases/start_quiz.dart';
import 'package:pdd_tests/features/training/presentation/format.dart';
import 'package:pdd_tests/features/training/presentation/pages/quiz_page.dart';
import 'package:pdd_tests/features/training/presentation/widgets/topic_tile.dart';

class ChaptersPage extends StatelessWidget {
  const ChaptersPage({
    super.key,
    required this.topics,
    required this.startQuiz,
  });

  final List<ChapterTopic> topics;
  final StartQuiz startQuiz;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Главы')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          for (final topic in topics) ...[
            SectionLabel(topic.title),
            if (topic.subtitle.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  topic.subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            for (final chapter in topic.chapters)
              TopicTile(
                title: chapter.name,
                subtitle: _meta(chapter),
                onTap: () {
                  final title =
                      chapter.title.isEmpty || chapter.title == chapter.name
                      ? chapter.name
                      : '${chapter.name}. ${chapter.title}';
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => QuizPage(
                        startQuiz: startQuiz,
                        request: ChapterQuizRequest(
                          chapterId: chapter.id,
                          title: title,
                        ),
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

  String _meta(ChapterSummary chapter) {
    final count = ruCount(
      chapter.questionCount,
      'вопрос',
      'вопроса',
      'вопросов',
    );
    if (chapter.title.isEmpty || chapter.title == chapter.name) {
      return count;
    }
    return '${chapter.title} · $count';
  }
}
