Duration getRepetitionInterval(int repetition) {
  var a = 0;
  var b = 1;

  for (int i = 0; i < repetition; ++i) {
    (a, b) = (b, a + b);
  }

  return Duration(days: a);
}
