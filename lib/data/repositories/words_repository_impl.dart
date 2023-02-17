import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:voca/data/repositories/assets_repository_impl.dart';
import 'package:voca/data/utils/pos_map.dart';
import 'package:voca/domain/entities/dictionary_entry.dart';
import 'package:voca/domain/entities/word.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/domain/entities/word_card_meta.dart';
import 'package:voca/domain/entities/word_card_short.dart';
import 'package:voca/domain/repositories/words_repository.dart';

@LazySingleton(as: WordsRepository)
class WordsRepositoryImpl implements WordsRepository {
  Database? _db;
  Future<Database> get db async {
    if (_db == null) {
      debugPrint('initializing db');

      _db = await openDatabase(
        join(await getDatabasesPath(), AssetsRepositoryImpl.enDictionaryDbName),
      );

      await _detachAllDb(_db!);
      await _attachUserProgressDb(_db!);
    }

    return _db!;
  }

  @override
  Future<List<WordCardShort>> findWords(String query) async {
    final db = await this.db;

    final qWords = await db.rawQuery('''
      SELECT rowid, word FROM word WHERE word LIKE ?
    ''', [
      '$query%',
    ]);

    final words = <WordCardShort>[];

    for (final row in qWords) {
      final word = row['word'] as String;
      final wordId = row['rowid'] as int;

      words.add(WordCardShort(
        word: Word(name: word, id: wordId),
        cardData: const WordCardMeta(
          repetitionCount: 3,
          status: WordCardStatus.learningOrLearned,
        ),
      ));
    }

    return words;
  }

  @override
  Future<WordCard> fetchWordCard(Word word) async {
    final db = await this.db;

    final qDefinitions = await db.rawQuery('''
      SELECT rowId, definition, pos FROM definition 
      WHERE wordId = ?
    ''', [
      word.id,
    ]);

    final definitions = <WordDefinition>[];

    for (final row in qDefinitions) {
      final definitionId = row['rowid'] as int;
      final definition = row['definition'] as String;
      final pos = row['pos'] as String;

      final qExamples = await db.rawQuery('''
        SELECT example FROM example WHERE definitionId = ?
      ''', [
        definitionId,
      ]);

      final examples = <String>[];

      for (final row in qExamples) {
        final example = row['example'] as String;

        examples.add(example);
      }

      definitions.add(WordDefinition(
        definition: definition,
        examples: UnmodifiableListView(examples),
        pos: posMap[pos]!,
      ));
    }

    return WordCard(
      dictionaryEntry: DictionaryEntry(
        definitions: UnmodifiableListView(definitions),
        word: word,
      ),
      cardData: const WordCardMeta(
        repetitionCount: 2,
        status: WordCardStatus.learningOrLearned,
      ),
    );
  }

  @override
  Future<void> addWordToKnownList(Word word) async {
    final db = await this.db;

    await db.execute('''
      INSERT INTO known(wordId, word)
      VALUES (?, ?)
    ''', [
      word.id,
      word.name,
    ]);
  }

  @override
  Future<void> addWordToLearnList(Word word) async {
    final db = await this.db;

    await db.execute('''
      INSERT INTO up.learning(wordId, word, lastRepetition) 
      VALUES (?, ?, ?)
    ''', [
      word.id,
      word.name,
      DateTime.now().millisecondsSinceEpoch,
    ]);
  }

  /// For hot reload - sqflite connection persists even after hotreload, so I
  /// get an error when attaching another database
  Future<void> _detachAllDb(Database mainConnection) async {
    final dbs = await mainConnection.rawQuery('''
      SELECT name FROM pragma_database_list
      WHERE name <> 'main'
    ''');

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
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE learning (
            wordId INTEGER UNIQUE NOT NULL,
            word TEXT, 
            repetitions INTEGER DEFAULT 0,
            lastRepetition INTEGER
          )
        ''');
        db.execute('''
          CREATE TABLE known (
            wordId INTEGER UNIQUE NOT NULL,
            word TEXT
          )
        ''');
      },
    );
    await updb.close();

    await mainConnection.execute('ATTACH ? AS up', [upPath]);
  }
}
