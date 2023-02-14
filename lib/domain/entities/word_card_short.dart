import 'package:voca/domain/entities/word.dart';

/// Only most important info about a word card
class WordCardShort {
  const WordCardShort({
    required this.word,
    this.status = WordCardStatus.unknown,
    this.repetitionCount = 0,
  });

  final Word word;
  final int repetitionCount;
  final WordCardStatus status;
}

enum WordCardStatus {
  unknown,

  /// Also includes learned words ([repetitionCount] == [maxRepetitionCount])
  learning,

  markedKnown,
}
