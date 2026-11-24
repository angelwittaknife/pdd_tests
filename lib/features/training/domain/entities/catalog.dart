import 'package:equatable/equatable.dart';

enum TicketSection { themes, subjects, complex }

final class TicketTopic extends Equatable {
  const TicketTopic({
    required this.catTicketId,
    required this.section,
    required this.title,
    required this.subtitle,
    required this.ticketCount,
    required this.questionCount,
  });

  final int catTicketId;
  final TicketSection section;
  final String title;
  final String subtitle;
  final int ticketCount;
  final int questionCount;

  @override
  List<Object?> get props => [
    catTicketId,
    section,
    title,
    subtitle,
    ticketCount,
    questionCount,
  ];
}

final class ChapterSummary extends Equatable {
  const ChapterSummary({
    required this.id,
    required this.name,
    required this.title,
    required this.questionCount,
  });

  final int id;
  final String name;
  final String title;
  final int questionCount;

  @override
  List<Object?> get props => [id, name, title, questionCount];
}

final class ChapterTopic extends Equatable {
  const ChapterTopic({
    required this.themeId,
    required this.title,
    required this.subtitle,
    required this.chapters,
  });

  final int themeId;
  final String title;
  final String subtitle;
  final List<ChapterSummary> chapters;

  @override
  List<Object?> get props => [themeId, title, subtitle, chapters];
}

final class ExamTopic extends Equatable {
  const ExamTopic({
    required this.catTicketId,
    required this.section,
    required this.title,
    required this.subtitle,
    required this.ticketCount,
  });

  final int catTicketId;
  final TicketSection section;
  final String title;
  final String subtitle;
  final int ticketCount;

  @override
  List<Object?> get props => [
    catTicketId,
    section,
    title,
    subtitle,
    ticketCount,
  ];
}

final class Catalog extends Equatable {
  const Catalog({
    required this.tickets,
    required this.chapters,
    required this.exams,
  });

  final List<TicketTopic> tickets;
  final List<ChapterTopic> chapters;
  final List<ExamTopic> exams;

  @override
  List<Object?> get props => [tickets, chapters, exams];
}
