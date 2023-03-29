import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:voca/data/managers/assets_manager/assets_manager.dart';
import 'package:voca/data/managers/database_manager/database_manager.dart';
import 'package:voca/data/utils/card_status.dart';
import 'package:voca/data/utils/days_since_epoch.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/injectable/injectable_init.dart';

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
      version: 3,
      onUpgrade: (db, prev, curr) async {
        debugPrint('WordsRepository database onUpgrade');

        if (prev <= 1) {
          await _updateDb1(db);
        }
        if (prev <= 3) {
          await _updateDb2(db);
        }
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

  Future<void> _updateDb1(Database db) async {
    final qUserWords = await db.query('userWords');

    for (final row in qUserWords) {
      final lastRepetitionMillisecs = row['lastRepetition'] as int;
      final wordId = row['wordId'] as int;

      db.update(
        'userWords',
        {
          'lastRepetition': millisecondsToDays(lastRepetitionMillisecs),
        },
        where: 'wordId = ?',
        whereArgs: [wordId],
      );
    }
  }

  Future<void> _updateDb2(Database db) async {
    db.update(
      'userWords',
      {
        'status': CardStatus.statusToText[WordCardStatus.unknown],
      },
      where: 'status = ?',
      whereArgs: ['known'],
    );
  }
}
