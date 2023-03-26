import 'dart:io';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:voca/data/managers/assets_manager/assets_manager.dart';

@LazySingleton()
class AssetsManagerImpl implements AssetsManager {
  /// If there is no dictionary database in the databases path (when the app is
  /// run for the first time), copies the db from assets. Otherwise does
  /// nothing.
  @override
  Future<void> copyDictionaryDbFromAssets() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, AssetsManager.enDictionaryDbName);

    final exists = await databaseExists(path);

    if (!exists) {
      await _copyDatabase(path);
    }
  }

  Future<void> _copyDatabase(String path) async {
    await Directory(dirname(path)).create(recursive: true);

    ByteData data = await rootBundle.load(
      join("assets", AssetsManager.enDictionaryDbName),
    );
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    await File(path).writeAsBytes(bytes, flush: true);
  }
}
