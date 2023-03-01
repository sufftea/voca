import 'package:voca/domain/entities/word.dart';

class WordCard {
  const WordCard({
    required this.word,
    required this.repetitionCount,
    required this.status
  });

  final Word word;
  final int repetitionCount;
  final WordCardStatus status;
}

enum WordCardStatus {
  unknown,

  learningOrLearned,

  known,
}
