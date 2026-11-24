import 'package:flutter_test/flutter_test.dart';
import 'package:pdd_tests/app/pdd_app.dart';
import 'package:pdd_tests/features/training/domain/entities/catalog.dart';
import 'package:pdd_tests/features/training/domain/entities/question.dart';
import 'package:pdd_tests/features/training/domain/entities/quiz_session.dart';

import 'support/fake_training_repository.dart';

void main() {
  testWidgets('ticket opens a question and reveals the explanation', (
    tester,
  ) async {
    const session = QuizSession(
      kind: QuizKind.ticket,
      title: 'Билет',
      allowedMistakes: null,
      questions: [
        Question(
          id: 1,
          text: 'Показанный участок — перекрёсток?',
          imageAsset: null,
          answers: [
            AnswerOption(id: 10, text: 'Да, является.', isCorrect: false),
            AnswerOption(id: 11, text: 'Нет, не является.', isCorrect: true),
          ],
          comment: [
            CommentTextPiece('Перекрёстка нет.', bold: false, italic: false),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      PddApp(
        repository: FakeTrainingRepository(
          catalog: const Catalog(
            tickets: [
              TicketTopic(
                catTicketId: 211,
                section: TicketSection.themes,
                title: 'Тема 1',
                subtitle: 'Главы 1–6',
                ticketCount: 1,
                questionCount: 10,
              ),
            ],
            chapters: [],
            exams: [],
          ),
          session: session,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Билеты по темам'), findsOneWidget);
    expect(find.text('Вопросы по главам'), findsOneWidget);
    expect(find.text('Зачёты по темам'), findsOneWidget);

    await tester.tap(find.text('Билеты по темам'));
    await tester.pumpAndSettle();
    expect(find.text('Тема 1'), findsOneWidget);

    await tester.tap(find.text('Тема 1'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('1'));
    await tester.pumpAndSettle();

    expect(find.text('Показанный участок — перекрёсток?'), findsOneWidget);
    await tester.tap(find.text('Нет, не является.'));
    await tester.pumpAndSettle();

    expect(find.text('Перекрёстка нет.'), findsOneWidget);
    expect(find.text('Пояснение'), findsOneWidget);
  });
}
