import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pdd_tests/features/training/domain/repositories/training_repository.dart';
import 'package:pdd_tests/features/training/domain/usecases/get_catalog.dart';
import 'package:pdd_tests/features/training/domain/usecases/start_quiz.dart';
import 'package:pdd_tests/features/training/presentation/pages/home_page.dart';
import 'package:pdd_tests/features/training/presentation/theme/pdd_theme.dart';

class PddApp extends StatelessWidget {
  const PddApp({super.key, required this.repository});

  final TrainingRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ПДД',
      debugShowCheckedModeBanner: false,
      theme: buildPddTheme(),
      scrollBehavior: const _PddScrollBehavior(),
      home: HomePage(
        getCatalog: GetCatalog(repository),
        startQuiz: StartQuiz(repository),
      ),
    );
  }
}

class PddStartupErrorApp extends StatelessWidget {
  const PddStartupErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ПДД',
      debugShowCheckedModeBanner: false,
      theme: buildPddTheme(),
      home: const Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Не удалось открыть базу вопросов.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class _PddScrollBehavior extends MaterialScrollBehavior {
  const _PddScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => const {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
  };
}
