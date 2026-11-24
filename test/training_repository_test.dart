import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:pdd_tests/core/error/result.dart';
import 'package:pdd_tests/features/training/data/datasources/training_local_data_source.dart';
import 'package:pdd_tests/features/training/data/repositories/training_repository_impl.dart';
import 'package:pdd_tests/features/training/domain/entities/question.dart';
import 'package:pdd_tests/features/training/domain/entities/quiz_session.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('catalog, ticket and exam come from questions.sqlite', () async {
    final database = await openDatabase(
      '${Directory.current.path}/data/open_source_tests1/questions.sqlite',
      readOnly: true,
    );
    addTearDown(database.close);

    final source = TrainingLocalDataSource(database);
    final repository = TrainingRepositoryImpl(source, random: Random(7));

    final catalogResult = await repository.getCatalog();
    final catalog = switch (catalogResult) {
      Success(:final value) => value,
      FailureResult(:final failure) => fail(failure.message),
    };

    final theme1 = catalog.tickets.firstWhere(
      (topic) => topic.catTicketId == 211,
    );
    expect(theme1.title, 'Тема 1');
    expect(theme1.ticketCount, 45);
    expect(theme1.questionCount, 445);

    final theme7 = catalog.tickets.firstWhere(
      (topic) => topic.catTicketId == 217,
    );
    expect(theme7.title, 'Тема 7');
    expect(theme7.title.contains('\u00A0'), isFalse);

    final rules = catalog.chapters.firstWhere((topic) => topic.themeId == 1);
    expect(rules.chapters.first.id, 1);
    expect(rules.chapters.first.questionCount, 273);
    expect(catalog.exams, hasLength(catalog.tickets.length));

    final ticketResult = await repository.loadTicket(
      catTicketId: 211,
      ticketNumber: 1,
      title: 'Тема 1 · билет 1',
    );
    final ticket = switch (ticketResult) {
      Success(:final value) => value,
      FailureResult(:final failure) => fail(failure.message),
    };
    expect(ticket.questions, hasLength(10));
    expect(ticket.questions.first.imageAsset, isNull);
    expect(ticket.questions.last.imageAsset, isNotNull);
    expect(File(ticket.questions.last.imageAsset!).existsSync(), isTrue);
    for (final question in ticket.questions) {
      expect(question.text.contains('\u00A0'), isFalse);
      expect(
        question.answers.where((answer) => answer.isCorrect),
        hasLength(1),
      );
      for (final piece in question.comment) {
        if (piece is CommentImagePiece) {
          expect(piece.assetPath.contains('/MED/'), isFalse);
          expect(File(piece.assetPath).existsSync(), isTrue);
        }
      }
    }

    final chapterResult = await repository.loadChapter(
      chapterId: 70,
      title: 'Глава 11',
    );
    final chapter = switch (chapterResult) {
      Success(:final value) => value,
      FailureResult(:final failure) => fail(failure.message),
    };
    expect(chapter.questions, hasLength(1));
    expect(chapter.allowedMistakes, isNull);

    final firstExam = await _examIds(repository);
    final second = TrainingRepositoryImpl(source, random: Random(7));
    final secondExam = await _examIds(second);
    expect(firstExam, secondExam);
    expect(firstExam.length, inInclusiveRange(18, 20));

    final other = TrainingRepositoryImpl(source, random: Random(8));
    expect(await _examIds(other), isNot(firstExam));

    final wholeTheme = await repository.loadExam(
      catTicketId: 217,
      title: 'Зачёт · Тема 7',
      ticketCount: 50,
      allowedMistakes: 0,
    );
    final whole = switch (wholeTheme) {
      Success(:final value) => value,
      FailureResult(:final failure) => fail(failure.message),
    };
    expect(whole.questions, hasLength(135));
    expect(whole.allowedMistakes, 0);

    final oneTicket = await repository.loadExam(
      catTicketId: 217,
      title: 'Зачёт · Тема 7',
      ticketCount: 1,
      allowedMistakes: 40,
    );
    final single = switch (oneTicket) {
      Success(:final value) => value,
      FailureResult(:final failure) => fail(failure.message),
    };
    expect(single.questions.length, inInclusiveRange(9, 10));
    expect(single.allowedMistakes, single.questions.length);
  });
}

Future<List<int>> _examIds(TrainingRepositoryImpl repository) async {
  final result = await repository.loadExam(
    catTicketId: 211,
    title: 'Зачёт · Тема 1',
    ticketCount: 2,
    allowedMistakes: 2,
  );
  final session = switch (result) {
    Success(:final value) => value,
    FailureResult(:final failure) => fail(failure.message),
  };
  expect(session.kind, QuizKind.exam);
  expect(session.allowedMistakes, 2);
  return [for (final question in session.questions) question.id];
}
