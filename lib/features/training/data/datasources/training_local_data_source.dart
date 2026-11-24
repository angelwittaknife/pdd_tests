import 'package:pdd_tests/features/training/data/comment_html.dart';
import 'package:pdd_tests/features/training/data/pdd_text.dart';
import 'package:pdd_tests/features/training/domain/entities/catalog.dart';
import 'package:pdd_tests/features/training/domain/entities/question.dart';
import 'package:sqflite/sqflite.dart';

class TrainingLocalDataSource {
  TrainingLocalDataSource(this._database);

  final Database _database;

  Future<List<TicketTopic>> ticketTopics() async {
    final rows = await _database.rawQuery('''
      SELECT
        c.ID AS id,
        c.TicketType AS ticket_type,
        CASE
          WHEN th.Name IS NULL OR th.Name = '' THEN c.Name
          ELSE th.Name
        END AS title,
        CASE
          WHEN th.Title IS NULL OR th.Title = '' THEN c.Title
          ELSE th.Title
        END AS subtitle,
        COUNT(DISTINCT t.TicketNum) AS ticket_count,
        COUNT(DISTINCT t.Question) AS question_count
      FROM CatTickets c
      LEFT JOIN tb_Themes th ON th.ID = c.Theme
      JOIN TicketsContent t ON t.CatTicketID = c.ID
      GROUP BY c.ID
      ORDER BY CASE c.TicketType WHEN 1 THEN 0 WHEN 2 THEN 1 ELSE 2 END, c.ID
    ''');

    return [
      for (final row in rows)
        TicketTopic(
          catTicketId: asInt(row['id']),
          section: _section(asInt(row['ticket_type'])),
          title: asText(row['title']),
          subtitle: _subtitle(asText(row['title']), asText(row['subtitle'])),
          ticketCount: asInt(row['ticket_count']),
          questionCount: asInt(row['question_count']),
        ),
    ];
  }

  Future<List<ChapterTopic>> chapterTopics() async {
    final rows = await _database.rawQuery('''
      SELECT
        th.ID AS theme_id,
        th.Name AS theme_name,
        th.Title AS theme_title,
        ch.ID AS chapter_id,
        ch.Name AS chapter_name,
        ch.Title AS chapter_title,
        COUNT(DISTINCT qi.ID_Question) AS question_count
      FROM tb_ThemeChapter tc
      JOIN tb_Themes th ON th.ID = tc.ID_Theme
      JOIN tb_Chapters ch ON ch.ID = tc.ID_Chapter
      JOIN tb_ChapterItemPDD ci ON ci.ID_Chapter = ch.ID
      JOIN QuestionItems qi ON qi.ID_Item = ci.ID_Item
      GROUP BY ch.ID, th.ID
      HAVING question_count > 0
      ORDER BY th.r_SortOrder, tc.SortOrder, ch.ID
    ''');

    final order = <int>[];
    final titles = <int, ({String title, String subtitle})>{};
    final chapters = <int, List<ChapterSummary>>{};

    for (final row in rows) {
      final themeId = asInt(row['theme_id']);
      final title = asText(row['theme_name']);
      titles.putIfAbsent(
        themeId,
        () => (
          title: title,
          subtitle: _subtitle(title, asText(row['theme_title'])),
        ),
      );
      chapters.putIfAbsent(themeId, () {
        order.add(themeId);
        return <ChapterSummary>[];
      });
      chapters[themeId]!.add(
        ChapterSummary(
          id: asInt(row['chapter_id']),
          name: asText(row['chapter_name']),
          title: asText(row['chapter_title']),
          questionCount: asInt(row['question_count']),
        ),
      );
    }

    return [
      for (final themeId in order)
        ChapterTopic(
          themeId: themeId,
          title: titles[themeId]!.title,
          subtitle: titles[themeId]!.subtitle,
          chapters: chapters[themeId]!,
        ),
    ];
  }

  Future<List<int>> ticketQuestionIds({
    required int catTicketId,
    required int ticketNumber,
  }) async {
    final rows = await _database.rawQuery(
      '''
      SELECT Question
      FROM TicketsContent
      WHERE CatTicketID = ? AND TicketNum = ?
      ORDER BY Position, ID
      ''',
      [catTicketId, ticketNumber],
    );
    return [for (final row in rows) asInt(row['Question'])];
  }

  Future<List<int>> ticketNumbers(int catTicketId) async {
    final rows = await _database.rawQuery(
      '''
      SELECT DISTINCT TicketNum
      FROM TicketsContent
      WHERE CatTicketID = ?
      ORDER BY TicketNum
      ''',
      [catTicketId],
    );
    return [for (final row in rows) asInt(row['TicketNum'])];
  }

  Future<List<int>> chapterQuestionIds(int chapterId) async {
    final rows = await _database.rawQuery(
      '''
      SELECT qi.ID_Question AS Question
      FROM tb_ChapterItemPDD ci
      JOIN QuestionItems qi ON qi.ID_Item = ci.ID_Item
      JOIN Items i ON i.ID = ci.ID_Item
      WHERE ci.ID_Chapter = ?
      GROUP BY qi.ID_Question
      ORDER BY MIN(i.SortOrder), qi.ID_Question
      ''',
      [chapterId],
    );
    return [for (final row in rows) asInt(row['Question'])];
  }

  Future<List<Question>> questionsByIds(List<int> ids) async {
    if (ids.isEmpty) {
      return const [];
    }

    // SQLite на Android принимает не больше 999 переменных в одном запросе.
    const batchSize = 400;
    final questionsById = <int, Map<String, Object?>>{};
    final answersByQuestion = <int, List<AnswerOption>>{};
    for (var start = 0; start < ids.length; start += batchSize) {
      final end = start + batchSize < ids.length
          ? start + batchSize
          : ids.length;
      final batch = ids.sublist(start, end);
      final placeholders = List.filled(batch.length, '?').join(',');
      final questionRows = await _database.rawQuery('''
        SELECT ID, Text, FileName, Coment
        FROM Questions
        WHERE ID IN ($placeholders)
        ''', batch);
      for (final row in questionRows) {
        questionsById[asInt(row['ID'])] = row;
      }

      final answerRows = await _database.rawQuery('''
        SELECT ID, ID_Question, Text, isTrue
        FROM Answers
        WHERE ID_Question IN ($placeholders)
        ORDER BY ID_Question, ViewOrder, ID
        ''', batch);
      for (final row in answerRows) {
        final questionId = asInt(row['ID_Question']);
        answersByQuestion
            .putIfAbsent(questionId, () => <AnswerOption>[])
            .add(
              AnswerOption(
                id: asInt(row['ID']),
                text: asText(row['Text']),
                isCorrect: asInt(row['isTrue']) == 1,
              ),
            );
      }
    }

    return [
      for (final id in ids)
        if (questionsById[id] != null)
          Question(
            id: id,
            text: asText(questionsById[id]!['Text']),
            imageAsset: questionImageAsset(questionsById[id]!['FileName']),
            answers: answersByQuestion[id] ?? const [],
            comment: parseCommentHtml(questionsById[id]!['Coment'] as String?),
          ),
    ];
  }

  TicketSection _section(int ticketType) {
    return switch (ticketType) {
      1 => TicketSection.themes,
      2 => TicketSection.subjects,
      _ => TicketSection.complex,
    };
  }

  String _subtitle(String title, String subtitle) {
    if (subtitle.isEmpty || subtitle == title) {
      return '';
    }
    return subtitle;
  }
}
