import 'package:equatable/equatable.dart';
import 'package:pdd_tests/features/training/domain/entities/question.dart';

enum QuizKind { ticket, chapter, exam }

final class QuizSession extends Equatable {
  const QuizSession({
    required this.kind,
    required this.title,
    required this.questions,
    required this.allowedMistakes,
  });

  final QuizKind kind;
  final String title;
  final List<Question> questions;

  /// Допуск зачёта. Для билета и главы допуска нет.
  final int? allowedMistakes;

  @override
  List<Object?> get props => [kind, title, questions, allowedMistakes];
}

sealed class QuizRequest extends Equatable {
  const QuizRequest();
}

final class TicketQuizRequest extends QuizRequest {
  const TicketQuizRequest({
    required this.catTicketId,
    required this.ticketNumber,
    required this.title,
  });

  final int catTicketId;
  final int ticketNumber;
  final String title;

  @override
  List<Object?> get props => [catTicketId, ticketNumber, title];
}

final class ChapterQuizRequest extends QuizRequest {
  const ChapterQuizRequest({required this.chapterId, required this.title});

  final int chapterId;
  final String title;

  @override
  List<Object?> get props => [chapterId, title];
}

final class ExamQuizRequest extends QuizRequest {
  const ExamQuizRequest({
    required this.catTicketId,
    required this.title,
    required this.ticketCount,
    required this.allowedMistakes,
  });

  final int catTicketId;
  final String title;
  final int ticketCount;
  final int allowedMistakes;

  @override
  List<Object?> get props => [catTicketId, title, ticketCount, allowedMistakes];
}
