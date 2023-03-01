import 'package:voca/domain/entities/word_card.dart';

abstract class PracticeRepository {
  Future<List<WordCard>> createPracticeList();

  Future<void> incrementCard(WordCard card);

  
}
