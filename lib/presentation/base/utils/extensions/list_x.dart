extension IterableX<T> on Iterable<T> {
  Iterable<(int, T)> enumerate() {
    int i = 0;
    return map((e) => (i++, e));
  }
}
