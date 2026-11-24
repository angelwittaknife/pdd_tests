import 'package:flutter/material.dart';
import 'package:pdd_tests/features/training/domain/entities/question.dart';
import 'package:pdd_tests/features/training/presentation/widgets/zoomable_asset_image.dart';

class CommentView extends StatelessWidget {
  const CommentView({super.key, required this.pieces});

  final List<CommentPiece> pieces;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4);
    final blocks = <Widget>[];
    final spans = <InlineSpan>[];

    void flushText() {
      if (spans.isEmpty) {
        return;
      }
      blocks.add(
        Text.rich(TextSpan(style: style, children: List<InlineSpan>.of(spans))),
      );
      spans.clear();
    }

    for (final piece in pieces) {
      switch (piece) {
        case CommentTextPiece(:final text, :final bold, :final italic):
          spans.add(
            TextSpan(
              text: text,
              style: TextStyle(
                fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
                fontStyle: italic ? FontStyle.italic : FontStyle.normal,
              ),
            ),
          );
        case CommentBreak():
          flushText();
          blocks.add(const SizedBox(height: 8));
        case CommentImagePiece(:final assetPath):
          flushText();
          blocks.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ZoomableAssetImage(assetPath: assetPath, height: 120),
            ),
          );
      }
    }
    flushText();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: blocks,
    );
  }
}
