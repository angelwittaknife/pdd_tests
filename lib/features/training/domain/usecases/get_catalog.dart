import 'package:pdd_tests/core/error/result.dart';
import 'package:pdd_tests/core/usecase/usecase.dart';
import 'package:pdd_tests/features/training/domain/entities/catalog.dart';
import 'package:pdd_tests/features/training/domain/repositories/training_repository.dart';

final class GetCatalog implements UseCase<Catalog, NoParams> {
  const GetCatalog(this._repository);

  final TrainingRepository _repository;

  @override
  Future<Result<Catalog>> call(NoParams params) {
    return _repository.getCatalog();
  }
}
