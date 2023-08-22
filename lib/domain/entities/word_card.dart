import 'package:equatable/equatable.dart';
import 'package:voca/domain/entities/word.dart';

class WordCard extends Equatable {
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

  @override
  // TODO: implement props
  List<Object?> get props => [
        word,
        repetitionCount,
        status,
        lastRepetition,
      ];

  WordCard copyWith({
    Word? word,
    int? repetitionCount,
    WordCardStatus? status,
    DateTime? lastRepetition,
  }) {
    return WordCard(
      word: word ?? this.word,
      repetitionCount: repetitionCount ?? this.repetitionCount,
      status: status ?? this.status,
      lastRepetition: lastRepetition ?? this.lastRepetition,
    );
  }
}

enum WordCardStatus {
  unknown,

  learning,
}
