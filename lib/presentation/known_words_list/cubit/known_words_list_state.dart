import 'dart:collection';

import 'package:voca/domain/entities/word_card.dart';

class KnownWordsListState {
  const KnownWordsListState({
    this.words,
  });

  final UnmodifiableListView<WordCard>? words;

  KnownWordsListState copyWith({
    UnmodifiableListView<WordCard>? words,
  }) {
    return KnownWordsListState(
      words: words ?? this.words,
    );
  }
}
