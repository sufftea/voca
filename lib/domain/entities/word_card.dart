import 'package:voca/domain/entities/word.dart';

class WordCard {
  const WordCard({
    required this.word,
    required this.repetitionCount,
    required this.status,
    this.lastRepetition,
  });

  final Word word;
  final int repetitionCount;
  final WordCardStatus status;

  /// Nullable because it's not needed most of the time. 
  /// If `null`, you shouldn't be using it.
  final DateTime? lastRepetition;
}

enum WordCardStatus {
  unknown,

  learningOrLearned,

  known,
}
