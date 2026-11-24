import 'package:pdd_tests/core/error/result.dart';
import 'package:pdd_tests/features/training/domain/entities/catalog.dart';
import 'package:pdd_tests/features/training/domain/entities/quiz_session.dart';
import 'package:pdd_tests/features/training/domain/repositories/training_repository.dart';

final class FakeTrainingRepository implements TrainingRepository {
  FakeTrainingRepository({required this.catalog, required this.session});

  final Catalog catalog;
  final QuizSession session;

  @override
  Future<Result<Catalog>> getCatalog() async => Success(catalog);

  @override
  Future<Result<QuizSession>> loadTicket({
    required int catTicketId,
    required int ticketNumber,
    required String title,
  }) async {
    return Success(_titled(title));
  }

  @override
  Future<Result<QuizSession>> loadChapter({
    required int chapterId,
    required String title,
  }) async {
    return Success(_titled(title));
  }

  @override
  Future<Result<QuizSession>> loadExam({
    required int catTicketId,
    required String title,
    required int ticketCount,
    required int allowedMistakes,
  }) async {
    return Success(
      QuizSession(
        kind: session.kind,
        title: title,
        questions: session.questions,
        allowedMistakes: allowedMistakes,
      ),
    );
  }

  @override
  Future<Result<QuizSession>> loadMistakes({
    required List<int> questionIds,
  }) async {
    final questions = [
      for (final id in questionIds)
        if (session.questions.any((question) => question.id == id))
          session.questions.firstWhere((question) => question.id == id),
    ];
    return Success(
      QuizSession(
        kind: QuizKind.mistakes,
        title: 'Коробка ошибок',
        questions: questions,
        allowedMistakes: null,
      ),
    );
  }

  QuizSession _titled(String title) {
    return QuizSession(
      kind: session.kind,
      title: title,
      questions: session.questions,
      allowedMistakes: session.allowedMistakes,
    );
  }
}
