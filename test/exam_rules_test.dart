import 'package:flutter_test/flutter_test.dart';
import 'package:pdd_tests/features/training/domain/exam_rules.dart';

void main() {
  test('ticket and mistake counts stay inside the available range', () {
    expect(ExamRules.clampCount(2, min: 1, max: 45), 2);
    expect(ExamRules.clampCount(0, min: 1, max: 45), 1);
    expect(ExamRules.clampCount(80, min: 1, max: 14), 14);
    expect(ExamRules.clampCount(-1, min: 0, max: 20), 0);
    expect(ExamRules.clampCount(25, min: 0, max: 19), 19);
    expect(ExamRules.mistakeLimit(2), 20);
    expect(ExamRules.mistakeLimit(0), 0);
  });
}
