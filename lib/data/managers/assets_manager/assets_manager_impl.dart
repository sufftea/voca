import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:voca/data/managers/assets_manager/assets_manager.dart';

const _enDictionaryVersionKey = 'en_dictionary_version';
const _lastDictVersion = 1;

@LazySingleton()
class AssetsManagerImpl implements AssetsManager {
  AssetsManagerImpl(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  /// If there is no dictionary database in the databases path (when the app is
  /// run for the first time), copies the db from assets. Otherwise does
  /// nothing.
  @override
  Future<void> copyDictionaryDbFromAssets() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, AssetsManager.enDictionaryDbName);

    final exists = await databaseExists(path);

    final dictVersion = _sharedPreferences.getInt(_enDictionaryVersionKey) ?? 0;

    if (!exists || dictVersion < _lastDictVersion) {
      _sharedPreferences.setInt(_enDictionaryVersionKey, _lastDictVersion);
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
