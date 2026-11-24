import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:pdd_tests/core/error/result.dart';
import 'package:pdd_tests/features/training/data/datasources/training_local_data_source.dart';
import 'package:pdd_tests/features/training/data/repositories/training_repository_impl.dart';
import 'package:pdd_tests/features/training/domain/entities/catalog.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('release 22 catalog comes from decoded/questions.sqlite', () async {
    final database = await openDatabase(
      '${Directory.current.path}/decoded/questions.sqlite',
      readOnly: true,
    );
    addTearDown(database.close);

    final repository = TrainingRepositoryImpl(
      TrainingLocalDataSource(database),
      random: Random(7),
    );
    final catalog = switch (await repository.getCatalog()) {
      Success(:final value) => value,
      FailureResult(:final failure) => fail(failure.message),
    };

    final themeOne = catalog.tickets.firstWhere(
      (topic) => topic.title == 'Тема 1',
    );
    expect(themeOne.section, TicketSection.themes);
    expect(themeOne.subtitle, 'Главы 1–6');
    expect(themeOne.questionCount, 515);
    expect(themeOne.ticketCount, 52);

    final complex = catalog.tickets.singleWhere(
      (topic) => topic.section == TicketSection.complex,
    );
    expect(complex.ticketCount, 299);
    expect(complex.questionCount, 2990);

    final rules = catalog.chapters.firstWhere((topic) => topic.themeId == 1);
    expect(rules.chapters.map((chapter) => chapter.name), [
      'Глава 1',
      'Глава 2',
      'Глава 3',
      'Глава 4',
      'Глава 5',
      'Глава 6',
    ]);
    expect(rules.chapters.first.questionCount, 251);

    final chapter = switch (await repository.loadChapter(
      chapterId: rules.chapters.first.id,
      title: 'Глава 1',
    )) {
      Success(:final value) => value,
      FailureResult(:final failure) => fail(failure.message),
    };
    expect(chapter.questions, hasLength(251));

    final ticket = switch (await repository.loadTicket(
      catTicketId: themeOne.catTicketId,
      ticketNumber: 1,
      title: 'Тема 1 · билет 1',
    )) {
      Success(:final value) => value,
      FailureResult(:final failure) => fail(failure.message),
    };
    final pictured = ticket.questions.firstWhere(
      (question) => question.id == 4,
    );
    expect(pictured.imageAsset, 'decoded/images/11383307.jpg');
    expect(ticket.questions, hasLength(10));
    expect(
      ticket.questions.every(
        (question) =>
            question.answers.where((answer) => answer.isCorrect).length == 1,
      ),
      isTrue,
    );
    expect(ticket.questions.first.comment, isNotEmpty);
  });
}
