import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:voca/data/utils/assets_manager.dart';

@LazySingleton()
class DatabaseManager {
  Database? _db;
  Database get db =>
      _db ?? (throw StateError("DatabaseRepository wasn't initialized"));

  Future<void> init() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), AssetsManager.enDictionaryDbName),
    );

    assert(await () async {
      await _detachAllDb(_db!);
      return true;
    }());

    await _attachUserProgressDb(_db!);
  }

  /// For hot reload - sqflite connection persists even after hotreload, so I
  /// get an error when attaching another database
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
    final upPath = join(
      await getDatabasesPath(),
      'en_user_progress.db',
    );

    // wordId - references words in the dictionary db; **not a primary key**.
    final updb = await openDatabase(
      upPath,
      version: 1,
      onUpgrade: (db, _, __) {
        debugPrint('WordsRepository database onUpgrade()');

        db.execute('''DROP TABLE learning''');
        db.execute('''DROP TABLE known''');

        // status - see [_WordCardStatusText]
        db.execute('''
          CREATE TABLE userWords (
            wordId INTEGER UNIQUE NOT NULL,
            word TEXT, 
            repetitions INTEGER DEFAULT 0,
            lastRepetition INTEGER,
            status TEXT
          )
        ''');
      },
    );
    await updb.close();

    await mainConnection.execute('ATTACH ? AS up', [upPath]);
  }
}
