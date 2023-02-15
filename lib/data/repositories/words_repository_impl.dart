import 'dart:collection';

import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:voca/data/utils/pos_map.dart';
import 'package:voca/domain/entities/dictionary_entry.dart';
import 'package:voca/domain/entities/word.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/domain/entities/word_card_meta.dart';
import 'package:voca/domain/entities/word_card_short.dart';
import 'package:voca/domain/repositories/words_repository.dart';

@LazySingleton(as: WordsRepository)
class WordsRepositoryImpl implements WordsRepository {
  Future<Database>? _db;
  Future<Database> get db async {
    _db ??= openDatabase(
      join(await getDatabasesPath(), 'en_dictionary.db'),
      readOnly: true,
    );

    return _db!;
  }

  @override
  Future<List<WordCardShort>> findWords(String word) async {
    final db = await this.db;

    final qWords = await db.rawQuery('''
      SELECT rowid, word FROM word WHERE word LIKE ?
    ''', [
      '$word%',
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
}
