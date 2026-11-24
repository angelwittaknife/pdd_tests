import 'package:flutter_test/flutter_test.dart';
import 'package:pdd_tests/features/training/domain/entities/catalog.dart';
import 'package:pdd_tests/features/training/domain/entities/question.dart';
import 'package:pdd_tests/features/training/domain/entities/quiz_session.dart';
import 'package:pdd_tests/features/training/domain/usecases/start_quiz.dart';
import 'package:pdd_tests/features/training/presentation/cubit/quiz_cubit.dart';

import 'support/fake_training_repository.dart';

void main() {
  const session = QuizSession(
    kind: QuizKind.ticket,
    title: 'Билет',
    allowedMistakes: null,
    questions: [
      Question(
        id: 1,
        text: 'Первый',
        imageAsset: null,
        answers: [
          AnswerOption(id: 10, text: 'Нет', isCorrect: false),
          AnswerOption(id: 11, text: 'Да', isCorrect: true),
        ],
        comment: [CommentTextPiece('Потому что.', bold: false, italic: false)],
      ),
      Question(
        id: 2,
        text: 'Второй',
        imageAsset: null,
        answers: [AnswerOption(id: 20, text: 'А', isCorrect: true)],
        comment: [],
      ),
    ],
  );

  QuizCubit cubit() {
    return QuizCubit(
      StartQuiz(
        FakeTrainingRepository(
          catalog: const Catalog(tickets: [], chapters: [], exams: []),
          session: session,
        ),
      ),
    );
  }

  test(
    'an answer locks, and the result opens after the last question',
    () async {
      final quiz = cubit();
      addTearDown(quiz.close);

      await quiz.load(
        const TicketQuizRequest(
          catTicketId: 211,
          ticketNumber: 1,
          title: 'Билет 1',
        ),
      );

      quiz.openQuestion(1);
      expect((quiz.state as QuizInProgress).index, 0);

      quiz.selectAnswer(10);
      quiz.selectAnswer(11);
      expect((quiz.state as QuizInProgress).selectedAnswerIds[1], 10);

      quiz.next();
      expect((quiz.state as QuizInProgress).index, 1);

      quiz.next();
      expect((quiz.state as QuizInProgress).showingResult, isFalse);

      quiz.selectAnswer(20);
      quiz.next();

      final done = quiz.state as QuizInProgress;
      expect(done.showingResult, isTrue);
      expect(done.correctCount, 1);
    },
  );
}
