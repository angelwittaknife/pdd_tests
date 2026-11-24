import 'package:flutter/material.dart';
import 'package:pdd_tests/features/training/domain/entities/catalog.dart';
import 'package:pdd_tests/features/training/domain/exam_rules.dart';
import 'package:pdd_tests/features/training/presentation/format.dart';
import 'package:pdd_tests/features/training/presentation/theme/pdd_theme.dart';
import 'package:pdd_tests/features/training/presentation/widgets/pdd_frame.dart';
import 'package:pdd_tests/features/training/presentation/widgets/theme_brightness_button.dart';

final class ExamChoice {
  const ExamChoice({required this.tickets, required this.mistakes});

  final int tickets;
  final int mistakes;
}

class ExamSetupPage extends StatefulWidget {
  const ExamSetupPage({
    super.key,
    required this.topic,
    required this.initialTickets,
    required this.initialMistakes,
  });

  final ExamTopic topic;
  final int initialTickets;
  final int initialMistakes;

  @override
  State<ExamSetupPage> createState() => _ExamSetupPageState();
}

class _ExamSetupPageState extends State<ExamSetupPage> {
  late int _tickets;
  late int _mistakes;

  @override
  void initState() {
    super.initState();
    _tickets = ExamRules.clampCount(
      widget.initialTickets,
      min: 1,
      max: widget.topic.ticketCount,
    );
    _mistakes = ExamRules.clampCount(
      widget.initialMistakes,
      min: 0,
      max: ExamRules.mistakeLimit(_tickets),
    );
  }

  void _setTickets(int value) {
    final tickets = ExamRules.clampCount(
      value,
      min: 1,
      max: widget.topic.ticketCount,
    );
    setState(() {
      _tickets = tickets;
      _mistakes = ExamRules.clampCount(
        _mistakes,
        min: 0,
        max: ExamRules.mistakeLimit(tickets),
      );
    });
  }

  void _setMistakes(int value) {
    setState(() {
      _mistakes = ExamRules.clampCount(
        value,
        min: 0,
        max: ExamRules.mistakeLimit(_tickets),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final available = widget.topic.ticketCount;
    final questionCap = ExamRules.mistakeLimit(_tickets);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic.title),
        actions: const [ThemeBrightnessButton()],
      ),
      body: PddFrame(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                children: [
                  Text(
                    widget.topic.subtitle.isEmpty
                        ? 'В теме ${ruCount(available, 'билет', 'билета', 'билетов')}.'
                        : '${widget.topic.subtitle}. В теме ${ruCount(available, 'билет', 'билета', 'билетов')}.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Берутся случайные билеты целиком. В билете до 10 вопросов.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _CountControl(
                    label: 'Билеты',
                    detail: ruCount(_tickets, 'билет', 'билета', 'билетов'),
                    value: _tickets,
                    min: 1,
                    max: available,
                    valueKey: const Key('exam-ticket-count'),
                    lessKey: const Key('exam-ticket-less'),
                    moreKey: const Key('exam-ticket-more'),
                    onChanged: _setTickets,
                  ),
                  const SizedBox(height: 12),
                  _CountControl(
                    label: 'Ошибки',
                    detail: examAllowance(_mistakes),
                    value: _mistakes,
                    min: 0,
                    max: questionCap,
                    valueKey: const Key('exam-mistake-count'),
                    lessKey: const Key('exam-mistake-less'),
                    moreKey: const Key('exam-mistake-more'),
                    onChanged: _setMistakes,
                  ),
                ],
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    key: const Key('exam-start'),
                    onPressed: available < 1
                        ? null
                        : () {
                            Navigator.of(context).pop(
                              ExamChoice(
                                tickets: _tickets,
                                mistakes: _mistakes,
                              ),
                            );
                          },
                    child: const Text('Начать зачёт'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountControl extends StatelessWidget {
  const _CountControl({
    required this.label,
    required this.detail,
    required this.value,
    required this.min,
    required this.max,
    required this.valueKey,
    required this.lessKey,
    required this.moreKey,
    required this.onChanged,
  });

  final String label;
  final String detail;
  final int value;
  final int min;
  final int max;
  final Key valueKey;
  final Key lessKey;
  final Key moreKey;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final span = max - min;

    return Material(
      color: context.pdd.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  Text(
                    detail,
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  key: lessKey,
                  tooltip: 'Меньше',
                  onPressed: value > min ? () => onChanged(value - 1) : null,
                  icon: const Icon(Icons.remove),
                ),
                Text(
                  '$value',
                  key: valueKey,
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                IconButton(
                  key: moreKey,
                  tooltip: 'Больше',
                  onPressed: value < max ? () => onChanged(value + 1) : null,
                  icon: const Icon(Icons.add),
                ),
                if (span > 0)
                  Expanded(
                    child: Slider(
                      min: min.toDouble(),
                      max: max.toDouble(),
                      divisions: span,
                      value: value.toDouble(),
                      label: '$value',
                      onChanged: (next) => onChanged(next.round()),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
