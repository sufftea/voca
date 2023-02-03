class WordRange {
  const WordRange({
    required this.low,
    required this.high,
  }) : assert(low < high);

  final int low, high;

  int get amount => high - low;
}
