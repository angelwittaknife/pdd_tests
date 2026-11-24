import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:pdd_tests/features/training/presentation/theme/theme_mode_cubit.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'
    show databaseFactoryFfi, sqfliteFfiInit;

class FileThemeModeStore implements ThemeModeStore {
  const FileThemeModeStore();

  @override
  Future<ThemeMode?> read() async {
    final file = await _file();
    if (!await file.exists()) {
      return null;
    }
    return _decode((await file.readAsString()).trim());
  }

  @override
  Future<void> write(ThemeMode mode) async {
    final file = await _file();
    await file.parent.create(recursive: true);
    await file.writeAsString(_encode(mode), flush: true);
  }

  Future<File> _file() async {
    if (Platform.isWindows) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    final directory = await getDatabasesPath();
    return File(path.join(directory, 'pdd_theme.txt'));
  }

  ThemeMode? _decode(String value) {
    return switch (value) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => null,
    };
  }

  String _encode(ThemeMode mode) {
    return mode == ThemeMode.dark ? 'dark' : 'light';
  }
}
