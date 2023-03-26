import 'dart:io';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:voca/data/managers/assets_manager/assets_manager.dart';

import '../../injectable/configure_test_dependencies.dart';

@LazySingleton(as: AssetsManager, env: [testEnv])
class AssetsManagerMock implements AssetsManager {
  @override
  Future<void> copyDictionaryDbFromAssets() async {
    final databasesPath = await databaseFactoryFfi.getDatabasesPath();
    final path = join(databasesPath, AssetsManager.enDictionaryDbName);

    final exists = await databaseFactoryFfi.databaseExists(path);

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
