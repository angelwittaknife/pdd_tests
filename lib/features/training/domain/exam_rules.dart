abstract final class ExamRules {
  static const int defaultTickets = 2;
  static const int defaultMistakes = 2;
  static const int questionsPerTicket = 10;

  static int clampCount(int requested, {required int min, required int max}) {
    if (max < min) {
      return min;
    }
    if (requested < min) {
      return min;
    }
    if (requested > max) {
      return max;
    }
    return requested;
  }

  /// Верхняя граница допуска до загрузки билетов: в билете не больше 10 вопросов.
  static int mistakeLimit(int ticketCount) {
    if (ticketCount < 1) {
      return 0;
    }
    return ticketCount * questionsPerTicket;
  }
}
