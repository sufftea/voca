import 'package:voca/domain/entities/word.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/domain/entities/word_card_short.dart';

abstract class WordsRepository {
  Future<List<WordCardShort>> findWords(String word);
  Future<WordCard> fetchWordCard(Word word);
}
