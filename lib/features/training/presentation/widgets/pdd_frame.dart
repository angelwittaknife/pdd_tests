import 'package:flutter/material.dart';

class PddFrame extends StatelessWidget {
  const PddFrame({super.key, required this.child});

  final Widget child;

  static const maxWidth = 920.0;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
