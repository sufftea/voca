import 'dart:collection';

import 'package:voca/domain/entities/dictionary_entry.dart';
import 'package:voca/domain/entities/word.dart';
import 'package:voca/domain/entities/word_card.dart';

class WordDefinitionState {
  const WordDefinitionState({
    this.repetitionCount,
    this.maxRepetitionCount = 0,
    this.status,
    this.word,
    this.definitions,
  });

  final int? repetitionCount;
  final int maxRepetitionCount;
  final WordCardStatus? status;
  final Word? word;
  final UnmodifiableListView<WordDefinition>? definitions;

  WordCard? get card {
    if ((word, repetitionCount, status)
        case (Word word, int repetitions, WordCardStatus status)) {
      return WordCard(
        word: word,
        repetitionCount: repetitions,
        status: status,
      );
    }
    return null;
  }

  WordDefinitionState copyWith({
    int? repetitionCount,
    int? maxRepetitionCount,
    WordCardStatus? status,
    Word? word,
    UnmodifiableListView<WordDefinition>? definitions,
  }) {
    return WordDefinitionState(
      repetitionCount: repetitionCount ?? this.repetitionCount,
      maxRepetitionCount: maxRepetitionCount ?? this.maxRepetitionCount,
      status: status ?? this.status,
      word: word ?? this.word,
      definitions: definitions ?? this.definitions,
    );
  }
}
