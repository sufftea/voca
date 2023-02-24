class WordCardUserData {
  const WordCardUserData({
    required this.repetitionCount,
    required this.status,
  });

  final int repetitionCount;
  final WordCardStatus status;

  WordCardUserData copyWith({
    int? repetitionCount,
    WordCardStatus? status,
  }) {
    return WordCardUserData(
      repetitionCount: repetitionCount ?? this.repetitionCount,
      status: status ?? this.status,
    );
  }
}

enum WordCardStatus {
  unknown,

  learningOrLearned,

  known,
}
