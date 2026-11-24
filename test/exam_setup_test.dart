import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdd_tests/features/training/domain/entities/catalog.dart';
import 'package:pdd_tests/features/training/presentation/pages/exam_setup_page.dart';

void main() {
  testWidgets('setup returns the chosen ticket and mistake counts', (
    tester,
  ) async {
    ExamChoice? choice;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: TextButton(
                onPressed: () async {
                  choice = await Navigator.of(context).push<ExamChoice>(
                    MaterialPageRoute<ExamChoice>(
                      builder: (_) => const ExamSetupPage(
                        topic: ExamTopic(
                          catTicketId: 211,
                          section: TicketSection.themes,
                          title: 'Тема 1',
                          subtitle: 'Главы 1–6',
                          ticketCount: 45,
                        ),
                        initialTickets: 2,
                        initialMistakes: 2,
                      ),
                    ),
                  );
                },
                child: const Text('Открыть'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Открыть'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('exam-ticket-more')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('exam-mistake-more')));
    await tester.pump();

    expect(
      tester.widget<Text>(find.byKey(const Key('exam-ticket-count'))).data,
      '3',
    );
    expect(
      tester.widget<Text>(find.byKey(const Key('exam-mistake-count'))).data,
      '3',
    );

    await tester.tap(find.byKey(const Key('exam-start')));
    await tester.pumpAndSettle();
    expect(choice?.tickets, 3);
    expect(choice?.mistakes, 3);
  });

  testWidgets('setup clamps counts to the theme size', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ExamSetupPage(
          topic: ExamTopic(
            catTicketId: 240,
            section: TicketSection.subjects,
            title: 'Устройство',
            subtitle: '',
            ticketCount: 6,
          ),
          initialTickets: 10,
          initialMistakes: 100,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      tester.widget<Text>(find.byKey(const Key('exam-ticket-count'))).data,
      '6',
    );
    expect(
      tester.widget<Text>(find.byKey(const Key('exam-mistake-count'))).data,
      '60',
    );
  });
}
