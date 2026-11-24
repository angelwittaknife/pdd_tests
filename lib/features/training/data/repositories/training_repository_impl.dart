import 'dart:math';

import 'package:pdd_tests/core/error/failure.dart';
import 'package:pdd_tests/core/error/result.dart';
import 'package:pdd_tests/features/training/data/datasources/training_local_data_source.dart';
import 'package:pdd_tests/features/training/domain/entities/catalog.dart';
import 'package:pdd_tests/features/training/domain/entities/quiz_session.dart';
import 'package:pdd_tests/features/training/domain/exam_rules.dart';
import 'package:pdd_tests/features/training/domain/repositories/training_repository.dart';

final class TrainingRepositoryImpl implements TrainingRepository {
  TrainingRepositoryImpl(this._source, {Random? random})
    : _random = random ?? Random();

  final TrainingLocalDataSource _source;
  final Random _random;

  @override
  Future<Result<Catalog>> getCatalog() async {
    try {
      final tickets = await _source.ticketTopics();
      final chapters = await _source.chapterTopics();
      final exams = [
        for (final topic in tickets)
          ExamTopic(
            catTicketId: topic.catTicketId,
            section: topic.section,
            title: topic.section == TicketSection.complex
                ? 'Комплексный зачёт'
                : topic.title,
            subtitle: topic.subtitle,
            ticketCount: topic.ticketCount,
          ),
      ];
      return Success(
        Catalog(tickets: tickets, chapters: chapters, exams: exams),
      );
    } on Object {
      return const FailureResult(
        Failure('Не удалось прочитать базу вопросов.'),
      );
    }
  }

  @override
  Future<Result<QuizSession>> loadTicket({
    required int catTicketId,
    required int ticketNumber,
    required String title,
  }) {
    return _session(
      ids: () => _source.ticketQuestionIds(
        catTicketId: catTicketId,
        ticketNumber: ticketNumber,
      ),
      emptyMessage: 'Билет не найден.',
      kind: QuizKind.ticket,
      title: title,
    );
  }

  @override
  Future<Result<QuizSession>> loadChapter({
    required int chapterId,
    required String title,
  }) {
    return _session(
      ids: () => _source.chapterQuestionIds(chapterId),
      emptyMessage: 'В этой главе нет вопросов.',
      kind: QuizKind.chapter,
      title: title,
    );
  }

  @override
  Future<Result<QuizSession>> loadExam({
    required int catTicketId,
    required String title,
    required int ticketCount,
    required int allowedMistakes,
  }) async {
    try {
      final numbers = await _source.ticketNumbers(catTicketId);
      if (numbers.isEmpty) {
        return const FailureResult(Failure('В этой теме нет билетов.'));
      }
      final count = ExamRules.clampCount(
        ticketCount,
        min: 1,
        max: numbers.length,
      );
      final picked = List<int>.of(numbers)..shuffle(_random);
      final selected = picked.take(count).toList();
      final ids = <int>[];
      for (final number in selected) {
        ids.addAll(
          await _source.ticketQuestionIds(
            catTicketId: catTicketId,
            ticketNumber: number,
          ),
        );
      }
      final questions = await _source.questionsByIds(ids);
      if (questions.isEmpty) {
        return const FailureResult(Failure('В этой теме нет вопросов.'));
      }
      return Success(
        QuizSession(
          kind: QuizKind.exam,
          title: title,
          questions: questions,
          allowedMistakes: ExamRules.clampCount(
            allowedMistakes,
            min: 0,
            max: questions.length,
          ),
        ),
      );
    } on Object {
      return const FailureResult(Failure('Не удалось собрать зачёт.'));
    }
  }

  Future<Result<QuizSession>> _session({
    required Future<List<int>> Function() ids,
    required String emptyMessage,
    required QuizKind kind,
    required String title,
  }) async {
    try {
      final questionIds = await ids();
      if (questionIds.isEmpty) {
        return FailureResult(Failure(emptyMessage));
      }
      final questions = await _source.questionsByIds(questionIds);
      if (questions.isEmpty) {
        return FailureResult(Failure(emptyMessage));
      }
      return Success(
        QuizSession(
          kind: kind,
          title: title,
          questions: questions,
          allowedMistakes: null,
        ),
      );
    } on Object {
      return const FailureResult(Failure('Не удалось прочитать вопросы.'));
    }
  }
}
