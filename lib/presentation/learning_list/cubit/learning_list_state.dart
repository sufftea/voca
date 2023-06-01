import 'dart:collection';

import 'package:voca/domain/entities/word_card.dart';

class LearningListState {
  const LearningListState({
    this.words,
    this.maxRepetitionCount = 0,
  });

  final UnmodifiableListView<WordCard>? words;
  final int maxRepetitionCount;

  LearningListState copyWith({
    UnmodifiableListView<WordCard>? words,
    int? maxRepetitionCount,
  }) {
    return LearningListState(
      words: words ?? this.words,
      maxRepetitionCount: maxRepetitionCount ?? this.maxRepetitionCount,
    );
  }
}
