// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:voca/presentation/entities/word_range.dart';

class HomeState {
  const HomeState({
    this.wordsForPractice,
    this.learningListEmpty = false,
    this.nofWordsCurrentlyLearning,
    this.selectedWordRange,
  });

  final int? wordsForPractice;
  final bool learningListEmpty;

  final int? nofWordsCurrentlyLearning;
  final WordRange? selectedWordRange;

  HomeState copyWith({
    int? wordsForPractice,
    bool? learningListEmpty,
    int? nofWordsCurrentlyLearning,
    WordRange? selectedWordRange,
  }) {
    return HomeState(
      wordsForPractice: wordsForPractice ?? this.wordsForPractice,
      learningListEmpty: learningListEmpty ?? this.learningListEmpty,
      nofWordsCurrentlyLearning:
          nofWordsCurrentlyLearning ?? this.nofWordsCurrentlyLearning,
      selectedWordRange: selectedWordRange ?? this.selectedWordRange,
    );
  }
}
