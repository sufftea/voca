// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:collection';

import 'package:voca/domain/entities/dictionary_entry.dart';
import 'package:voca/domain/entities/word.dart';
import 'package:voca/domain/entities/word_card.dart';

class PracticeState {
  const PracticeState({
    this.cards,
    this.index = 0,
    this.isFlipped = false,
    this.definitions,
    this.maxRepetitionCount = 0,
    this.rememberedWords = 0,
    this.forgottenWords = 0,
  });

  final UnmodifiableListView<WordCard>? cards;
  final int index;
  final bool isFlipped;
  final UnmodifiableListView<WordDefinition>? definitions;
  final int maxRepetitionCount;

  final int rememberedWords;
  final int forgottenWords;

  PracticeState copyWith({
    UnmodifiableListView<WordCard>? cards,
    int? index,
    bool? isFlipped,
    UnmodifiableListView<WordDefinition>? definitions,
    int? maxRepetitionCount,
    int? rememberedWords,
    int? forgottenWords,
  }) {
    return PracticeState(
      cards: cards ?? this.cards,
      index: index ?? this.index,
      isFlipped: isFlipped ?? this.isFlipped,
      definitions: definitions ?? this.definitions,
      maxRepetitionCount: maxRepetitionCount ?? this.maxRepetitionCount,
      rememberedWords: rememberedWords ?? this.rememberedWords,
      forgottenWords: forgottenWords ?? this.forgottenWords,
    );
  }
}

class FullWordCard {
  FullWordCard({
    required this.word,
    required this.repetitionCount,
    required this.status,
    required this.definitions,
  });

  final Word word;
  final int repetitionCount;
  final WordCardStatus status;

  final UnmodifiableListView<WordDefinition> definitions;

  FullWordCard copyWith({
    Word? word,
    int? repetitionCount,
    WordCardStatus? status,
    UnmodifiableListView<WordDefinition>? definitions,
  }) {
    return FullWordCard(
      word: word ?? this.word,
      repetitionCount: repetitionCount ?? this.repetitionCount,
      status: status ?? this.status,
      definitions: definitions ?? this.definitions,
    );
  }
}
