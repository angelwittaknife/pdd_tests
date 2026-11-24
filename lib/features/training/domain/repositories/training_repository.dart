import 'package:pdd_tests/core/error/result.dart';
import 'package:pdd_tests/features/training/domain/entities/catalog.dart';
import 'package:pdd_tests/features/training/domain/entities/quiz_session.dart';

abstract interface class TrainingRepository {
  Future<Result<Catalog>> getCatalog();

  Future<Result<QuizSession>> loadTicket({
    required int catTicketId,
    required int ticketNumber,
    required String title,
  });

  Future<Result<QuizSession>> loadChapter({
    required int chapterId,
    required String title,
  });

  Future<Result<QuizSession>> loadExam({
    required int catTicketId,
    required String title,
    required int ticketCount,
    required int allowedMistakes,
  });
}
