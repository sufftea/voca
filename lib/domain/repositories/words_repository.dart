import 'package:voca/domain/entities/word.dart';

abstract class WordsRepository {
  Future<List<Word>> findWords(String word);
}
