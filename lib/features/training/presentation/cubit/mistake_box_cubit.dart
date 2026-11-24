import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdd_tests/features/training/domain/dataset_kind.dart';

abstract interface class MistakeRecord {
  void remember(int questionId);

  void forget(int questionId);
}

abstract interface class MistakeBoxStore {
  Future<List<int>> read(DatasetKind kind);

  Future<void> write(DatasetKind kind, List<int> questionIds);
}

class MistakeBoxCubit extends Cubit<List<int>> implements MistakeRecord {
  MistakeBoxCubit(this._store) : super(const []);

  final MistakeBoxStore? _store;
  DatasetKind? _kind;

  Future<void> open(DatasetKind kind) async {
    _kind = kind;
    final store = _store;
    if (store == null) {
      emit(const []);
      return;
    }
    try {
      emit(await store.read(kind));
    } on Object {
      emit(const []);
    }
  }

  @override
  void remember(int questionId) {
    if (state.contains(questionId)) {
      return;
    }
    final next = [...state, questionId];
    emit(next);
    unawaited(_persist(next));
  }

  @override
  void forget(int questionId) {
    if (!state.contains(questionId)) {
      return;
    }
    final next = [...state]..remove(questionId);
    emit(next);
    unawaited(_persist(next));
  }

  Future<void> _persist(List<int> questionIds) async {
    final store = _store;
    final kind = _kind;
    if (store == null || kind == null) {
      return;
    }
    try {
      await store.write(kind, questionIds);
    } on Object {
      // Список на экране уже обновлён. Файл подхватится при следующем ответе.
    }
  }
}
