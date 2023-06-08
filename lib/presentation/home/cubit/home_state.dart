class HomeState {
  const HomeState({
    this.wordsForPractice,
    this.learningListEmpty = false,
  });

  final int? wordsForPractice;
  final bool learningListEmpty;


  HomeState copyWith({
    int? wordsForPractice,
    bool? learningListEmpty,
  }) {
    return HomeState(
      wordsForPractice: wordsForPractice ?? this.wordsForPractice,
      learningListEmpty: learningListEmpty ?? this.learningListEmpty,
    );
  }
}
