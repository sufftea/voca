class WordRange {
  const WordRange({
    required this.lower,
    required this.upper,
    required this.knownWords,
    required this.learningWords,
  });

  final int lower;
  final int upper;
  final int knownWords;
  final int learningWords;
}
