import 'package:voca/domain/entities/dictionary_entry.dart';
import 'package:voca/domain/entities/word.dart';
import 'package:voca/domain/entities/word_card.dart';

abstract class WordsRepository {
  Future<List<WordCard>> findWords(String query);
  Future<DictionaryEntry> fetchDictionaryEntry(Word word);

  Future<void> setWordCardStatus(Word word, WordCardStatus status);

  Future<void> setWordCardRepetitions(Word word, int repetitions);

  Future<List<WordCard>> fetchLearningList();
}
