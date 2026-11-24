import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:pdd_tests/features/training/domain/dataset_kind.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'
    show databaseFactoryFfi, sqfliteFfiInit;

class QuestionsDatabase {
  static const classicAsset = 'data/open_source_tests1/questions.sqlite';
  static const release22Asset = 'decoded/questions.sqlite';

  /// Копия в каталоге баз перезаписывается, когда размер файла
  /// перестал совпадать с ассетом. Так обновление базы
  /// подхватывается без ручной очистки.
  static Future<Database> open(DatasetKind kind) async {
    if (Platform.isWindows) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    final assetPath = switch (kind) {
      DatasetKind.classic => classicAsset,
      DatasetKind.release22 => release22Asset,
    };
    final fileName = switch (kind) {
      DatasetKind.classic => 'pdd_questions_v1.sqlite',
      DatasetKind.release22 => 'pdd_questions_v2.sqlite',
    };
    final databasesPath = await getDatabasesPath();
    final dbPath = path.join(databasesPath, fileName);
    final asset = await rootBundle.load(assetPath);
    final bytes = asset.buffer.asUint8List(
      asset.offsetInBytes,
      asset.lengthInBytes,
    );
    final file = File(dbPath);
    final needsWrite =
        !await file.exists() || await file.length() != bytes.length;
    if (needsWrite) {
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes, flush: true);
    }
    return openDatabase(dbPath, readOnly: true);
  }
}
