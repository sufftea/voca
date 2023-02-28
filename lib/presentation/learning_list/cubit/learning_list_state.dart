import 'dart:collection';

import 'package:voca/domain/entities/word_card_short.dart';

class LearningListState {
  const LearningListState({
    this.words,
  });

  final UnmodifiableListView<WordCardShort>? words;

  LearningListState copyWith({
    UnmodifiableListView<WordCardShort>? words,
  }) {
    return LearningListState(
      words: words ?? this.words,
    );
  }
}
