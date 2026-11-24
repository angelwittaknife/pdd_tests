import 'package:equatable/equatable.dart';

final class AnswerOption extends Equatable {
  const AnswerOption({
    required this.id,
    required this.text,
    required this.isCorrect,
  });

  final int id;
  final String text;
  final bool isCorrect;

  @override
  List<Object?> get props => [id, text, isCorrect];
}

sealed class CommentPiece extends Equatable {
  const CommentPiece();
}

final class CommentTextPiece extends CommentPiece {
  const CommentTextPiece(this.text, {required this.bold, required this.italic});

  final String text;
  final bool bold;
  final bool italic;

  @override
  List<Object?> get props => [text, bold, italic];
}

final class CommentBreak extends CommentPiece {
  const CommentBreak();

  @override
  List<Object?> get props => const [];
}

final class CommentImagePiece extends CommentPiece {
  const CommentImagePiece(this.assetPath);

  final String assetPath;

  @override
  List<Object?> get props => [assetPath];
}

final class Question extends Equatable {
  const Question({
    required this.id,
    required this.text,
    required this.imageAsset,
    required this.answers,
    required this.comment,
  });

  final int id;
  final String text;
  final String? imageAsset;
  final List<AnswerOption> answers;
  final List<CommentPiece> comment;

  @override
  List<Object?> get props => [id, text, imageAsset, answers, comment];
}
