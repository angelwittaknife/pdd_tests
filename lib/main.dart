import 'package:flutter/material.dart';
import 'package:pdd_tests/app/pdd_app.dart';
import 'package:pdd_tests/features/training/data/datasources/questions_database.dart';
import 'package:pdd_tests/features/training/data/datasources/training_local_data_source.dart';
import 'package:pdd_tests/features/training/data/repositories/training_repository_impl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final database = await QuestionsDatabase.open();
    final repository = TrainingRepositoryImpl(
      TrainingLocalDataSource(database),
    );
    runApp(PddApp(repository: repository));
  } on Object {
    runApp(const PddStartupErrorApp());
  }
}
