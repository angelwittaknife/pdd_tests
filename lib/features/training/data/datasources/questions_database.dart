import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'
    show databaseFactoryFfi, sqfliteFfiInit;

class QuestionsDatabase {
  static const assetPath = 'data/open_source_tests1/questions.sqlite';

  /// Копия в каталоге баз перезаписывается, когда размер файла
  /// перестал совпадать с ассетом. Так обновление `questions.sqlite`
  /// подхватывается без ручной очистки.
  static Future<Database> open() async {
    if (Platform.isWindows) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    final databasesPath = await getDatabasesPath();
    final dbPath = path.join(databasesPath, 'pdd_questions.sqlite');
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
