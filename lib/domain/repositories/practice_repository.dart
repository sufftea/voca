import 'package:voca/domain/entities/word.dart';
import 'package:voca/domain/entities/word_card.dart';

abstract class PracticeRepository {
  Future<List<WordCard>> createPracticeList();

  /// throws if the word is not in the learning list
  Future<void> incrementCard(Word word);

  /// throws if the word is not in the learning list
  Future<void> resetCard(Word word);
}
