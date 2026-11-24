import 'package:pdd_tests/features/training/data/datasources/questions_database.dart';
import 'package:pdd_tests/features/training/data/datasources/training_local_data_source.dart';
import 'package:pdd_tests/features/training/data/repositories/training_repository_impl.dart';
import 'package:pdd_tests/features/training/domain/dataset_kind.dart';
import 'package:pdd_tests/features/training/domain/repositories/training_repository.dart';

Future<TrainingRepository> openTrainingRepository(DatasetKind kind) async {
  final database = await QuestionsDatabase.open(kind);
  return TrainingRepositoryImpl(TrainingLocalDataSource(database));
}
