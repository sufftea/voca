class WordRange {
  WordRange({
    required this.low,
    required this.high,
    this.learningNumber = 0,
    this.knowNumber = 0,
  })  : assert(learningNumber + knowNumber <= high - low),
        assert(high >= low);

  final int learningNumber;
  final int knowNumber;
  final int low, high;
  int get amount => high - low;
  int get unknown => amount - learningNumber - knowNumber;
}
