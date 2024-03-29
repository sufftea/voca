import 'dart:collection';

import 'package:clock/clock.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:voca/data/managers/database_manager/database_manager.dart';
import 'package:voca/data/utils/card_status.dart';
import 'package:voca/data/utils/days_since_epoch.dart';
import 'package:voca/data/utils/pos_map.dart';
import 'package:voca/domain/entities/dictionary_entry.dart';
import 'package:voca/domain/entities/word.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/domain/repositories/words_repository.dart';

@LazySingleton(as: WordsRepository)
class WordsRepositoryImpl implements WordsRepository {
  const WordsRepositoryImpl(this._databaseManager);

  final DatabaseManager _databaseManager;

  @override
  Future<List<WordCard>> findWords(String query) async {
    final db = _databaseManager.db;

    query = query.trim();
    final qWords = await db.query(
      'word',
      columns: ['wordId', 'word'],
      where: 'word LIKE ?',
      whereArgs: [
        query.replaceAll('', '%'),
      ],
      orderBy:
          "(word like '%$query') + (word like '$query%') + (word == '$query') DESC",
      limit: 100,
    );

    final words = <WordCard>[];

    for (final row in qWords) {
      final wordName = row['word'] as String;
      final wordId = row['wordId'] as int;

      final word = Word(id: wordId, name: wordName);

      final card = await fetchWordCard(word);

      if (card == null) {
        assert(card != null);
        return words;
      }

      words.add(card);
    }

    return words;
  }

  @override
  Future<WordCard?> fetchWordCard(Word word) async {
    final db = _databaseManager.db;

    try {
      final qUserWords = await db.query(
        'up.userWords',
        columns: ['wordId', 'repetitions', 'status'],
        where: 'wordId = ?',
        whereArgs: [word.id],
      );

      if (qUserWords.isEmpty) {
        return WordCard(
          word: word,
          repetitionCount: 0,
          status: WordCardStatus.unknown,
        );
      }

      assert(qUserWords.length == 1);

      final wordEntry = qUserWords.first;
      final repetitions = wordEntry['repetitions'] as int;
      final status = CardStatus.textToStatus[wordEntry['status'] as String]!;

      return WordCard(
        word: word,
        repetitionCount: repetitions,
        status: status,
      );
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Future<DictionaryEntry> fetchDictionaryEntry(Word word) async {
    final db = _databaseManager.db;

    final q = await db.rawQuery('''
      SELECT definitionId, definition, pos, frequency, example FROM definition 
      LEFT JOIN example USING(definitionId) 
      WHERE wordId = ?
    ''', [word.id]);

    /// definitionId : example list
    final exampleMap = <int, List<String>>{};

    for (final row in q) {
      final defId = row['definitionId'] as int;
      final example = row['example'] as String?;

      final currExamples = exampleMap[defId] ?? (exampleMap[defId] = []);

      if (example != null) {
        currExamples.add(example);
      }
    }

    final definitions = <WordDefinition>[];
    final defIdSet = <int>{};

    for (final row in q) {
      final defId = row['definitionId'] as int;

      if (!defIdSet.add(defId)) {
        continue;
      }

      final definition = row['definition'] as String;
      final pos = row['pos'] as String;
      final frequency = row['frequency'] as int;

      definitions.add(WordDefinition(
        definition: definition,
        examples: UnmodifiableListView(exampleMap[defId]!),
        pos: posMap[pos]!,
        frequency: frequency,
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
        'lastRepetition': clock.now().daysSinceEpoch,
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
        'status': CardStatus.statusToText[status],
        'lastRepetition': clock.now().daysSinceEpoch,
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
  Future<List<WordCard>> fetchLearningList() async {
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
        CardStatus.statusToText[WordCardStatus.learning],
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
        status: WordCardStatus.learning,
      ));
    }

    return words;
  }

  Future<void> _addWordToUserWords(
    Word word, {
    int repetitions = 0,
    WordCardStatus status = WordCardStatus.learning,
  }) async {
    final db = _databaseManager.db;

    assert(
      await () async {
        final qWords = await db.query(
          'word',
          columns: ['wordId, word'],
          where: 'wordId = ?',
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
        'lastRepetition': clock.now().daysSinceEpoch,
        'status': CardStatus.statusToText[status],
      },
    );

    assert(result != 0);
  }
}
