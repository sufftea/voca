// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:collection';

import 'package:voca/domain/entities/dictionary_entry.dart';
import 'package:voca/domain/entities/word.dart';
import 'package:voca/domain/entities/word_card_user_data.dart';

class WordDefinitionState {
  const WordDefinitionState({
    this.repetitionCount,
    this.status,
    this.word,
    this.definitions,
  });

  final int? repetitionCount;
  final WordCardStatus? status;
  final Word? word;
  final UnmodifiableListView<WordDefinition>? definitions;

  WordDefinitionState copyWith({
    int? repetitionCount,
    WordCardStatus? status,
    Word? word,
    UnmodifiableListView<WordDefinition>? definitions,
  }) {
    return WordDefinitionState(
      repetitionCount: repetitionCount ?? this.repetitionCount,
      status: status ?? this.status,
      word: word ?? this.word,
      definitions: definitions ?? this.definitions,
    );
  }
}
