import 'package:voca/domain/entities/word_range.dart';

class HomeState {
  HomeState({
    required this.selectedLanguage,
    required this.wordRange,
    required this.todaysGoal,
    required this.nofWordsCurrentlyLearning,
  });

  final String selectedLanguage;
  final WordRange wordRange;  
  final int todaysGoal;
  final int nofWordsCurrentlyLearning;

  HomeState copyWith({
    String? selectedLanguage,
    WordRange? wordRange,
    int? todaysGoal,
    int? nofWordsCurrentlyLearning,
  }) {
    return HomeState(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      wordRange: wordRange ?? this.wordRange,
      todaysGoal: todaysGoal ?? this.todaysGoal,
      nofWordsCurrentlyLearning: nofWordsCurrentlyLearning ?? this.nofWordsCurrentlyLearning,
    );
  }
}
