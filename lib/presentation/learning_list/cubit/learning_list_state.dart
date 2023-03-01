import 'dart:collection';

import 'package:voca/domain/entities/word_card.dart';

class LearningListState {
  const LearningListState({
    this.words,
  });

  final UnmodifiableListView<WordCard>? words;

  LearningListState copyWith({
    UnmodifiableListView<WordCard>? words,
  }) {
    return LearningListState(
      words: words ?? this.words,
    );
  }
}
