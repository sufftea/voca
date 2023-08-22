import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:voca/data/managers/assets_manager/assets_manager.dart';
import 'package:voca/data/managers/database_manager/database_manager.dart';
import 'package:voca/injectable/injectable_init.dart';

@LazySingleton(as: DatabaseManager, env: [InjectableEnv.integration])
class InMemoryDatabaseManager extends DatabaseManager {
  Database? _db;
  @override
  Database get db =>
      _db ??
      (throw StateError("IntegrationTestDatabaseManager: call init first"));

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
    await mainConnection.execute('ATTACH ? AS up', [inMemoryDatabasePath]);
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
