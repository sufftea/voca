import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:voca/data/utils/database_manager.dart';
import 'package:voca/data/utils/days_since_epoch.dart';
import 'package:voca/data/utils/pos_map.dart';
import 'package:voca/domain/entities/dictionary_entry.dart';
import 'package:voca/domain/entities/word.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/domain/repositories/words_repository.dart';
import 'package:voca/utils/global_constants.dart';

@LazySingleton(as: WordsRepository)
class WordsRepositoryImpl implements WordsRepository {
  const WordsRepositoryImpl(this._databaseManager);

  final DatabaseManager _databaseManager;

  @override
  Future<List<WordCard>> findWords(String query) async {
    final db = _databaseManager.db;

    final qWords = await db.query(
      'word',
      columns: ['rowid', 'word'],
      where: 'word LIKE ?',
      whereArgs: ['$query%'],
    );

    final words = <WordCard>[];

    for (final row in qWords) {
      final word = row['word'] as String;
      final wordId = row['rowid'] as int;

      // final userData = await _fetchUserWordData(wordId);
      final qUserWords = await db.query(
        'up.userWords',
        columns: ['wordId', 'repetitions', 'status'],
        where: 'wordId = ?',
        whereArgs: [wordId],
      );

      late final int repetitionCount;
      late final WordCardStatus status;

      if (qUserWords.isNotEmpty) {
        final row = qUserWords.first;

        repetitionCount = row['repetitions'] as int;
        status = DatabaseManager.textToWordStatus[row['status'] as String]!;
      } else {
        repetitionCount = 0;
        status = WordCardStatus.unknown;
      }

      words.add(WordCard(
        word: Word(name: word, id: wordId),
        repetitionCount: repetitionCount,
        status: status,
      ));
    }

    return words;
  }

  @override
  Future<DictionaryEntry> fetchDictionaryEntry(Word word) async {
    final db = _databaseManager.db;

    final qDefinitions = await db.query(
      'definition',
      columns: ['rowId', 'definition', 'pos'],
      where: 'wordId = ?',
      whereArgs: [word.id],
    );

    final definitions = <WordDefinition>[];

    for (final row in qDefinitions) {
      final definitionId = row['rowid'] as int;
      final definition = row['definition'] as String;
      final pos = row['pos'] as String;

      final qExamples = await db.query(
        'example',
        columns: ['example'],
        where: 'definitionId = ?',
        whereArgs: [definitionId],
      );

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

    return DictionaryEntry(
      definitions: UnmodifiableListView(definitions),
      word: word,
    );
  }

  @override
  Future<void> setWordCardRepetitions(Word word, int repetitions) async {
    final db = _databaseManager.db;

    final count = await db.update(
      'up.userWords',
      {
        'repetitions': repetitions,
        'lastRepetition': DateTime.now().daysSinceEpoch,
      },
      where: 'wordId = ?',
      whereArgs: [word.id],
    );

    if (count == 0) {
      _addWordToUserWords(
        word,
        repetitions: repetitions,
      );
    }

    assert(() {
      if (count > 1) {
        debugPrint('setWordCardRepetitions: count > 1');
      }

      return true;
    }());
  }

  @override
  Future<void> setWordCardStatus(
    Word word,
    WordCardStatus status,
  ) async {
    final db = _databaseManager.db;

    final count = await db.update(
      'up.userWords',
      {
        'status': DatabaseManager.wordStatusToText[status],
        'lastRepetition': DateTime.now().daysSinceEpoch,
      },
      where: 'wordId = ?',
      whereArgs: [word.id],
    );

    if (count == 0) {
      await _addWordToUserWords(
        word,
        status: status,
      );
    }

    assert(() {
      if (count > 1) {
        debugPrint('setWordCardStatus: count > 1');
      }

      return true;
    }());
  }

  @override
  Future<List<WordCard>> fetchLearningWords() async {
    final db = _databaseManager.db;

    final qWords = await db.query(
      'up.userWords',
      columns: [
        'wordId',
        'word',
        'repetitions',
      ],
      where: 'status = ?',
      whereArgs: [
        DatabaseManager.wordStatusToText[WordCardStatus.learningOrLearned],
      ],
    );

    final words = <WordCard>[];

    for (final row in qWords) {
      final wordId = row['wordId'] as int;
      final word = row['word'] as String;
      final repetitions = row['repetitions'] as int;

      words.add(WordCard(
        word: Word(name: word, id: wordId),
        repetitionCount: repetitions,
        status: WordCardStatus.learningOrLearned,
      ));
    }

    return words;
  }

  @override
  Future<List<WordCard>> fetchKnownWords() async {
    final db = _databaseManager.db;

    final qWords = await db.query(
      'up.userWords',
      columns: [
        'wordId',
        'word',
        'repetitions',
      ],
      where: 'status = ? OR repetitions = ?',
      whereArgs: [
        DatabaseManager.wordStatusToText[WordCardStatus.known],
        GlobalConstants.maxRepetitionCount,
      ],
    );

    final words = <WordCard>[];

    for (final row in qWords) {
      final wordId = row['wordId'] as int;
      final word = row['word'] as String;
      final repetitions = row['repetitions'] as int;

      words.add(WordCard(
        word: Word(name: word, id: wordId),
        repetitionCount: repetitions,
        status: WordCardStatus.known,
      ));
    }

    return words;
  }

  Future<void> _addWordToUserWords(
    Word word, {
    int repetitions = 0,
    WordCardStatus status = WordCardStatus.learningOrLearned,
  }) async {
    final db = _databaseManager.db;

    assert(
      await () async {
        final qWords = await db.query(
          'word',
          columns: ['rowId, word'],
          where: 'rowId = ?',
          whereArgs: [word.id],
        );

        return qWords.isNotEmpty;
      }(),
      "insertNewWord: word doesn't exist in the dictionary",
    );

    final result = await db.insert(
      'up.userWords',
      {
        'wordId': word.id,
        'word': word.name,
        'repetitions': repetitions,
        'lastRepetition': DateTime.now().daysSinceEpoch,
        'status': DatabaseManager.wordStatusToText[status],
      },
    );

    assert(result != 0);
  }
}
