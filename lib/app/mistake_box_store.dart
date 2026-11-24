import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:pdd_tests/features/training/domain/dataset_kind.dart';
import 'package:pdd_tests/features/training/presentation/cubit/mistake_box_cubit.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'
    show databaseFactoryFfi, sqfliteFfiInit;

class FileMistakeBoxStore implements MistakeBoxStore {
  const FileMistakeBoxStore();

  @override
  Future<List<int>> read(DatasetKind kind) async {
    final file = await _file(kind);
    if (!await file.exists()) {
      return const [];
    }
    return _decode(await file.readAsString());
  }

  @override
  Future<void> write(DatasetKind kind, List<int> questionIds) async {
    final file = await _file(kind);
    await file.parent.create(recursive: true);
    await file.writeAsString(_encode(questionIds), flush: true);
  }

  Future<File> _file(DatasetKind kind) async {
    if (Platform.isWindows) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    final directory = await getDatabasesPath();
    final name = switch (kind) {
      DatasetKind.classic => 'pdd_mistakes_v1.txt',
      DatasetKind.release22 => 'pdd_mistakes_v2.txt',
    };
    return File(path.join(directory, name));
  }

  List<int> _decode(String raw) {
    final ids = <int>[];
    for (final line in raw.split('\n')) {
      final id = int.tryParse(line.trim());
      if (id == null || ids.contains(id)) {
        continue;
      }
      ids.add(id);
    }
    return ids;
  }

  String _encode(List<int> questionIds) {
    if (questionIds.isEmpty) {
      return '';
    }
    return '${questionIds.join('\n')}\n';
  }
}
