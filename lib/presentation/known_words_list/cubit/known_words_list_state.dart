import 'dart:collection';

import 'package:voca/domain/entities/word_card_short.dart';

class KnownWordsListState {
  const KnownWordsListState({
    this.words,
  });

  final UnmodifiableListView<WordCardShort>? words;

  KnownWordsListState copyWith({
    UnmodifiableListView<WordCardShort>? words,
  }) {
    return KnownWordsListState(
      words: words ?? this.words,
    );
  }
}
