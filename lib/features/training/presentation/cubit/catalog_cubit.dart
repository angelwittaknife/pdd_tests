import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdd_tests/core/error/result.dart';
import 'package:pdd_tests/core/usecase/usecase.dart';
import 'package:pdd_tests/features/training/domain/entities/catalog.dart';
import 'package:pdd_tests/features/training/domain/usecases/get_catalog.dart';

sealed class CatalogState extends Equatable {
  const CatalogState();
}

final class CatalogLoading extends CatalogState {
  const CatalogLoading();

  @override
  List<Object?> get props => const [];
}

final class CatalogReady extends CatalogState {
  const CatalogReady(this.catalog);

  final Catalog catalog;

  @override
  List<Object?> get props => [catalog];
}

final class CatalogFailure extends CatalogState {
  const CatalogFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class CatalogCubit extends Cubit<CatalogState> {
  CatalogCubit(this._getCatalog) : super(const CatalogLoading());

  final GetCatalog _getCatalog;

  Future<void> load() async {
    emit(const CatalogLoading());
    final result = await _getCatalog(const NoParams());
    switch (result) {
      case Success(:final value):
        emit(CatalogReady(value));
      case FailureResult(:final failure):
        emit(CatalogFailure(failure.message));
    }
  }
}
