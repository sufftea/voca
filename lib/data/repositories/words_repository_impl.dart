import 'dart:collection';

import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:voca/data/utils/pos_map.dart';
import 'package:voca/domain/entities/dictionary_entry.dart';
import 'package:voca/domain/entities/word_card.dart';
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
  Future<SearchHandle<WordCard>> findWords(String word) async {
    return WordSearchHandle(
      db: await db,
      word: word,
    );
  }
}

class WordSearchHandle implements SearchHandle<WordCard> {
  WordSearchHandle({
    required this.db,
    required this.word,
  });

  final Database db;
  final String word;
  QueryCursor? wordsCursor;

  final List<WordCard> _results = [];
  var _closed = false;
  var _fetching = false;

  @override
  UnmodifiableListView<WordCard> get results => UnmodifiableListView(_results);

  @override
  bool get closed => _closed;

  @override
  Future<bool> fetchMore([int n = 50]) async {
    if (_fetching) {
      // add a getter to [_fetchMore]?
      throw StateError('[fetchMore] called before the previous call finished.');
    }
    _fetching = true;

    final wordCards = <WordCard>[];

    final wordsCursor = this.wordsCursor ??
        await db.rawQueryCursor('''
          SELECT rowid, word FROM word WHERE word LIKE ?
        ''', [
          '%$word%',
        ]);

    for (var i = 0; i < n; ++i) {
      final row = wordsCursor.current;

      if (!await wordsCursor.moveNext()) {
        _closed = true;
        return false;
      }

      final word = row['word'] as String;
      final wordId = row['rowid'] as int;

      final definitions = await _fetchDefinitions(wordId);

      wordCards.add(WordCard(
        word: DictionaryEntry(
          name: word,
          definitions: UnmodifiableListView(definitions),
        ),
      ));
    }

    _results.addAll(wordCards);

    _fetching = false;
    return true;
  }

  @override
  Future<bool> fetchAll() {
    throw UnimplementedError();
  }

  @override
  Future<void> close() async {
    _closed = true;
    await wordsCursor?.close();
  }

  Future<List<WordDefinition>> _fetchDefinitions(int wordId) async {
    final qDefinitions = await db.rawQuery('''
        SELECT rowid, definition, pos FROM definition WHERE wordId = ?
      ''', [
      wordId,
    ]);

    final definitions = <WordDefinition>[];

    for (final row in qDefinitions) {
      final definitionId = row['rowid'] as int;
      final definition = row['definition'] as String;
      final pos = row['pos'] as String;

      final examples = await _fetchExamples(definitionId);

      definitions.add(WordDefinition(
        definition: definition,
        examples: UnmodifiableListView(examples),
        pos: posMap[pos]!,
      ));
    }

    return definitions;
  }

  Future<List<String>> _fetchExamples(int definitionId) async {
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

    return examples;
  }
}
