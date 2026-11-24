import 'package:pdd_tests/core/error/result.dart';
import 'package:pdd_tests/core/usecase/usecase.dart';
import 'package:pdd_tests/features/training/domain/entities/quiz_session.dart';
import 'package:pdd_tests/features/training/domain/repositories/training_repository.dart';

final class StartQuiz implements UseCase<QuizSession, QuizRequest> {
  const StartQuiz(this._repository);

  final TrainingRepository _repository;

  @override
  Future<Result<QuizSession>> call(QuizRequest params) {
    return switch (params) {
      TicketQuizRequest(
        :final catTicketId,
        :final ticketNumber,
        :final title,
      ) =>
        _repository.loadTicket(
          catTicketId: catTicketId,
          ticketNumber: ticketNumber,
          title: title,
        ),
      ChapterQuizRequest(:final chapterId, :final title) =>
        _repository.loadChapter(chapterId: chapterId, title: title),
      ExamQuizRequest(
        :final catTicketId,
        :final title,
        :final ticketCount,
        :final allowedMistakes,
      ) =>
        _repository.loadExam(
          catTicketId: catTicketId,
          title: title,
          ticketCount: ticketCount,
          allowedMistakes: allowedMistakes,
        ),
    };
  }
}
