import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdd_tests/app/mistake_box_store.dart';
import 'package:pdd_tests/app/open_dataset.dart';
import 'package:pdd_tests/app/theme_mode_store.dart';
import 'package:pdd_tests/features/training/presentation/cubit/mistake_box_cubit.dart';
import 'package:pdd_tests/features/training/domain/repositories/training_repository.dart';
import 'package:pdd_tests/features/training/domain/usecases/get_catalog.dart';
import 'package:pdd_tests/features/training/domain/usecases/start_quiz.dart';
import 'package:pdd_tests/features/training/presentation/pages/dataset_page.dart';
import 'package:pdd_tests/features/training/presentation/pages/home_page.dart';
import 'package:pdd_tests/features/training/presentation/theme/pdd_theme.dart';
import 'package:pdd_tests/features/training/presentation/theme/theme_mode_cubit.dart';

class PddApp extends StatefulWidget {
  const PddApp({super.key, this.repository, this.themeStore});

  final TrainingRepository? repository;
  final ThemeModeStore? themeStore;

  @override
  State<PddApp> createState() => _PddAppState();
}

class _PddAppState extends State<PddApp> {
  late final ThemeModeCubit _theme = ThemeModeCubit(
    store: widget.themeStore ?? const FileThemeModeStore(),
  );
  late final MistakeBoxCubit _mistakes = MistakeBoxCubit(
    const FileMistakeBoxStore(),
  );

  @override
  void dispose() {
    _theme.close();
    _mistakes.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final opened = widget.repository;
    return BlocProvider.value(
      value: _theme,
      child: BlocBuilder<ThemeModeCubit, ThemeMode>(
        builder: (context, mode) {
          return MaterialApp(
            title: 'ПДД',
            debugShowCheckedModeBanner: false,
            theme: buildPddTheme(Brightness.light),
            darkTheme: buildPddTheme(Brightness.dark),
            themeMode: mode,
            scrollBehavior: const _PddScrollBehavior(),
            builder: (context, child) {
              return BlocProvider.value(
                value: _mistakes,
                child: child ?? const SizedBox.shrink(),
              );
            },
            home: opened == null
                ? DatasetPage(openDataset: openTrainingRepository)
                : HomePage(
                    getCatalog: GetCatalog(opened),
                    startQuiz: StartQuiz(opened),
                  ),
          );
        },
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
      theme: buildPddTheme(Brightness.light),
      darkTheme: buildPddTheme(Brightness.dark),
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
