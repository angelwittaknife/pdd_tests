import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ThemeModeStore {
  Future<ThemeMode?> read();

  Future<void> write(ThemeMode mode);
}

class ThemeModeCubit extends Cubit<ThemeMode> {
  ThemeModeCubit({this._store}) : super(ThemeMode.light) {
    final store = _store;
    if (store != null) {
      unawaited(_restore(store));
    }
  }

  final ThemeModeStore? _store;

  void toggle() {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(next);
    unawaited(_persist(next));
  }

  Future<void> _persist(ThemeMode mode) async {
    final store = _store;
    if (store == null) {
      return;
    }
    try {
      await store.write(mode);
    } on Object {
      // Тема уже переключена на экране. Файл настроек не обязателен.
    }
  }

  Future<void> _restore(ThemeModeStore store) async {
    try {
      final saved = await store.read();
      if (saved != null && !isClosed) {
        emit(saved);
      }
    } on Object {
      // Каталог настроек недоступен в тестах. Остаётся светлая тема.
    }
  }
}
