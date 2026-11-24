import 'package:flutter_test/flutter_test.dart';
import 'package:pdd_tests/features/training/data/comment_html.dart';
import 'package:pdd_tests/features/training/domain/entities/question.dart';

void main() {
  test('keeps bold text and maps a sign image', () {
    final pieces = parseCommentHtml(
      '<p>Дорога <strong>главная</strong> <img src="PDD/BY/IMG/signs/2_1.png" />.</p>',
    );

    final image = pieces.whereType<CommentImagePiece>().single;
    expect(image.assetPath, 'data/open_source_tests1/by/IMG/signs/2_1.png');

    final bold = pieces.whereType<CommentTextPiece>().singleWhere(
      (piece) => piece.text.contains('главная'),
    );
    expect(bold.bold, isTrue);
    expect(
      pieces.whereType<CommentTextPiece>().map((piece) => piece.text).join(),
      contains('Дорога '),
    );
  });

  test('lowercases the MED comment folder', () {
    final pieces = parseCommentHtml(
      '<p><img src="PDD/BY/IMG/MED/med_700102901.jpg" /></p>',
    );

    expect(
      pieces.whereType<CommentImagePiece>().single.assetPath,
      'data/open_source_tests1/by/IMG/med/med_700102901.jpg',
    );
  });

  test('keeps a release-22 sign path', () {
    final pieces = parseCommentHtml(
      '<p><img src="decoded/signs/Z040203.png" /></p>',
    );

    expect(
      pieces.whereType<CommentImagePiece>().single.assetPath,
      'decoded/signs/Z040203.png',
    );
  });

  test('turns list items into bullets', () {
    final pieces = parseCommentHtml('<ul><li>права</li><li>паспорт</li></ul>');
    final text = pieces
        .whereType<CommentTextPiece>()
        .map((piece) => piece.text)
        .join();

    expect(text, contains('• права'));
    expect(text, contains('• паспорт'));
  });

  test('replaces non-breaking spaces in the explanation', () {
    final pieces = parseCommentHtml('<p>два\u00A0слова</p>');
    expect(pieces.whereType<CommentTextPiece>().single.text, 'два слова');
  });
}
