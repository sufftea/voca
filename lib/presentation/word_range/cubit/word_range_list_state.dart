// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:voca/presentation/entities/word_range.dart';

@immutable
class WordRrangeListState {
  const WordRrangeListState({
    required this.ranges,
    required this.selectedRange,
  });

  final List<WordRange> ranges;
  final WordRange selectedRange;

  WordRrangeListState copyWith({
    List<WordRange>? ranges,
    WordRange? selectedRange,
  }) {
    return WordRrangeListState(
      ranges: ranges ?? this.ranges,
      selectedRange: selectedRange ?? this.selectedRange,
    );
  }
}
