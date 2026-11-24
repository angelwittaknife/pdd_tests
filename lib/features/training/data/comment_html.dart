import 'package:pdd_tests/features/training/domain/entities/question.dart';

final _tagPattern = RegExp(r'<[^>]+>');

List<CommentPiece> parseCommentHtml(String? raw) {
  if (raw == null || raw.trim().isEmpty) {
    return const [];
  }

  final pieces = <CommentPiece>[];
  var bold = 0;
  var italic = 0;
  var cursor = 0;
  final input = raw.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

  for (final match in _tagPattern.allMatches(input)) {
    _appendText(
      pieces,
      input.substring(cursor, match.start),
      bold: bold > 0,
      italic: italic > 0,
    );
    final tag = match.group(0)!;
    final name = _tagName(tag);
    final closing = tag.startsWith('</');
    switch (name) {
      case 'br':
        pieces.add(const CommentBreak());
      case 'p':
      case 'ul':
      case 'ol':
        _breakBeforeBlock(pieces, closing: closing);
      case 'h3':
      case 'h4':
        if (closing) {
          if (bold > 0) {
            bold -= 1;
          }
          pieces.add(const CommentBreak());
        } else {
          _breakBeforeBlock(pieces, closing: false);
          bold += 1;
        }
      case 'li':
        if (closing) {
          pieces.add(const CommentBreak());
        } else {
          _breakBeforeBlock(pieces, closing: false);
          pieces.add(const CommentTextPiece('• ', bold: true, italic: false));
        }
      case 'strong':
      case 'b':
      case 'ins':
        bold += closing ? (bold > 0 ? -1 : 0) : 1;
      case 'i':
      case 'em':
      case 'cite':
        italic += closing ? (italic > 0 ? -1 : 0) : 1;
      case 'img':
        final src = _attribute(tag, 'src');
        if (src != null && src.isNotEmpty) {
          pieces.add(CommentImagePiece(commentImageAsset(src)));
        }
      default:
        break;
    }
    cursor = match.end;
  }

  _appendText(
    pieces,
    input.substring(cursor),
    bold: bold > 0,
    italic: italic > 0,
  );
  return _collapse(pieces);
}

String commentImageAsset(String src) {
  var path = src.trim().replaceAll('\\', '/');
  path = path.replaceFirst(RegExp(r'^PDD/BY/IMG/', caseSensitive: false), '');
  final slash = path.indexOf('/');
  if (slash > 0) {
    final folder = path.substring(0, slash).toLowerCase();
    path = '$folder/${path.substring(slash + 1)}';
  }
  return 'data/open_source_tests1/by/IMG/$path';
}

void _appendText(
  List<CommentPiece> pieces,
  String raw, {
  required bool bold,
  required bool italic,
}) {
  final text = raw
      .replaceAll('\u00A0', ' ')
      .replaceAll('\u202F', ' ')
      .replaceAll('\n', ' ')
      .replaceAll(RegExp(r' {2,}'), ' ');
  final decoded = _decodeEntities(text);
  if (decoded.trim().isEmpty) {
    return;
  }
  pieces.add(CommentTextPiece(decoded, bold: bold, italic: italic));
}

void _breakBeforeBlock(List<CommentPiece> pieces, {required bool closing}) {
  if (!closing && pieces.isNotEmpty && pieces.last is! CommentBreak) {
    pieces.add(const CommentBreak());
  }
  if (closing) {
    pieces.add(const CommentBreak());
  }
}

String _tagName(String tag) {
  final match = RegExp(r'^</?\s*([a-zA-Z0-9]+)').firstMatch(tag);
  return match?.group(1)?.toLowerCase() ?? '';
}

String? _attribute(String tag, String name) {
  final match = RegExp(
    '$name\\s*=\\s*"([^"]*)"',
    caseSensitive: false,
  ).firstMatch(tag);
  return match?.group(1);
}

String _decodeEntities(String value) {
  return value
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&amp;', '&');
}

List<CommentPiece> _collapse(List<CommentPiece> pieces) {
  final collapsed = <CommentPiece>[];
  for (final piece in pieces) {
    if (piece is CommentBreak &&
        (collapsed.isEmpty || collapsed.last is CommentBreak)) {
      continue;
    }
    collapsed.add(piece);
  }
  while (collapsed.isNotEmpty && collapsed.last is CommentBreak) {
    collapsed.removeLast();
  }
  return collapsed;
}
