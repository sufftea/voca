class WordCardMeta {
  const WordCardMeta({
    required this.repetitionCount,
    required this.status,
  });

  final int repetitionCount;
  final WordCardStatus status;

  WordCardMeta copyWith({
    int? repetitionCount,
    WordCardStatus? status,
  }) {
    return WordCardMeta(
      repetitionCount: repetitionCount ?? this.repetitionCount,
      status: status ?? this.status,
    );
  }
}

enum WordCardStatus {
  unknown,

  learningOrLearned,

  markedKnown,
}
