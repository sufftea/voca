import 'dart:io';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:voca/domain/repositories/assets_repository.dart';
import 'package:path/path.dart';

@LazySingleton(as: AssetsRepository)
class AssetsRepositoryImpl implements AssetsRepository {
  @override
  Future<void> initDatabaseFromAssets() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "en_dictionary.db");

    final exists = await databaseExists(path);

    if (!exists) {
      _copyDatabase(path);
    }
  }

  Future<void> _copyDatabase(String path) async {
    await Directory(dirname(path)).create(recursive: true);

    ByteData data = await rootBundle.load(join("assets", "en_dictionary.db"));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    await File(path).writeAsBytes(bytes, flush: true);
  }
}
