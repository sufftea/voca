import 'package:voca/domain/entities/word.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/domain/entities/word_card_user_data.dart';
import 'package:voca/domain/entities/word_card_short.dart';

abstract class WordsRepository {
  Future<List<WordCardShort>> findWords(String query);
  Future<WordCard> fetchWordCard(Word word);

  Future<void> setWordCardStatus(Word word, WordCardStatus status);

  Future<void> setWordCardRepetitions(Word word, int repetitions);

  Future<List<WordCardShort>> fetchLearningWords();
}
