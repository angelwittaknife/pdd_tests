import 'package:flutter/material.dart';
import 'package:pdd_tests/features/training/presentation/theme/pdd_theme.dart';

class ZoomableAssetImage extends StatelessWidget {
  const ZoomableAssetImage({
    super.key,
    required this.assetPath,
    this.height = 240,
  });

  final String assetPath;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Увеличить изображение',
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => _ImageZoomPage(assetPath: assetPath),
            ),
          );
        },
        child: Container(
          height: height,
          width: double.infinity,
          alignment: Alignment.center,
          color: context.pdd.imageBackdrop,
          child: Image.asset(
            assetPath,
            width: double.infinity,
            height: height,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Text('Изображение не найдено');
            },
          ),
        ),
      ),
    );
  }
}

class _ImageZoomPage extends StatelessWidget {
  const _ImageZoomPage({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 1,
          maxScale: 4,
          child: Image.asset(assetPath, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
