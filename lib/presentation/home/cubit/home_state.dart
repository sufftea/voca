class HomeState {
  HomeState({
    required this.selectedLanguage,
    required this.todaysGoal,
    required this.todaysGoalCompleted,
    required this.nofWordsCurrentlyLearning,
  });

  final String selectedLanguage;
  final int todaysGoal;
  final int todaysGoalCompleted;
  final int nofWordsCurrentlyLearning;

  HomeState copyWith({
    String? selectedLanguage,
    int? todaysGoal,
    int? todaysGoalCompleted,
    int? nofWordsCurrentlyLearning,
  }) {
    return HomeState(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      todaysGoal: todaysGoal ?? this.todaysGoal,
      todaysGoalCompleted: todaysGoalCompleted ?? this.todaysGoalCompleted,
      nofWordsCurrentlyLearning:
          nofWordsCurrentlyLearning ?? this.nofWordsCurrentlyLearning,
    );
  }
}
