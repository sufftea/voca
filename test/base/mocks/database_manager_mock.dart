import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:voca/data/managers/assets_manager/assets_manager.dart';
import 'package:voca/data/managers/database_manager/database_manager.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../injectable/configure_test_dependencies.dart';

@LazySingleton(as: DatabaseManager, env: [testEnv])
class DatabaseManagerMock extends DatabaseManager {
  Database? _db;

  @override
  Database get db =>
      _db ?? (throw StateError("DatabaseManager: call init first"));

  @override
  Future<void> init() async {
    final path = join(
      await databaseFactoryFfi.getDatabasesPath(),
      AssetsManager.enDictionaryDbName,
    );

    _db = await databaseFactoryFfi.openDatabase(path);

    await _attachUserProgressDb(_db!);
  }

  Future<void> _attachUserProgressDb(Database mainConnection) async {
    await mainConnection.execute('ATTACH ? AS up', [':memory:']);

    await mainConnection.execute('''
      CREATE TABLE up.userWords (
        wordId INTEGER UNIQUE NOT NULL,
        word TEXT NOT NULL,
        repetitions INTEGER DEFAULT 0,
        lastRepetition INTEGER NOT NULL,
        status TEXT NOT NULL
      )
    ''');
  }
}
