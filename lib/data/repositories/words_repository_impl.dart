import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:voca/domain/entities/word.dart';
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
      '%$word%',
    ]);

    final words = <WordCardShort>[];

    for (final row in qWords) {
      final word = row['word'] as String;
      final wordId = row['rowid'] as int;

      words.add(WordCardShort(
        word: Word(name: word, id: wordId),
      ));
    }

    return words;
  }
}
