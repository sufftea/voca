import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:voca/data/managers/assets_manager/assets_manager.dart';
import 'package:voca/data/managers/database_manager/database_manager.dart';
import 'package:voca/injectable/injectable_init.dart';
import 'package:voca/utils/flavors.dart';

@LazySingleton(as: DatabaseManager, env: [mainEnv])
class DatabaseManagerImpl implements DatabaseManager {
  Database? _db;
  @override
  Database get db =>
      _db ?? (throw StateError("DatabaseManager: call init first"));

  @override
  Future<void> init() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), AssetsManager.enDictionaryDbName),
    );

    await _detachAllDb(_db!);

    await _attachUserProgressDb(_db!);
  }

  Future<void> _detachAllDb(Database mainConnection) async {
    final dbs = await mainConnection.query(
      'pragma_database_list',
      columns: ['name'],
      where: "name <> 'main'",
    );

    for (final row in dbs) {
      final name = row['name'];
      mainConnection.execute('DETACH ?', [name]);
    }
  }

  Future<void> _attachUserProgressDb(Database mainConnection) async {
    final upPath =
        join(await getDatabasesPath(), DatabaseManager.userProgressPath);

    // wordId - references words in the dictionary db; **not a primary key**.
    final updb = await openDatabase(
      upPath,
      version: Flavors.current == Flavors.production ? 1 : 1,
      onUpgrade: (db, prev, curr) async {
        debugPrint('WordsRepository database onUpgrade');
      },
      onCreate: (db, version) async {
        debugPrint('WordsRepository database onCreate');
        // status - see [_WordCardStatusText]
        await db.execute('''
          CREATE TABLE userWords (
            wordId INTEGER UNIQUE NOT NULL,
            word TEXT NOT NULL, 
            repetitions INTEGER DEFAULT 0,
            lastRepetition INTEGER NOT NULL,
            status TEXT NOT NULL
          )
        ''');
      },
    );
    await updb.close();

    await mainConnection.execute('ATTACH ? AS up', [upPath]);
  }
}
