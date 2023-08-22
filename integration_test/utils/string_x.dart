extension StringX on String {
  String trimIndent() {
    final lines = split('\n');

    int minIndent = lines
        .where((line) => line.trim().isNotEmpty)
        .map((line) => line.indexOf(RegExp(r'[^\s]')))
        .where((index) => index != -1)
        .fold(
            lines[0].length,
            (minIndent, currentIndent) =>
                currentIndent < minIndent ? currentIndent : minIndent);

    final trimmedLines = lines.map((line) {
      final t = line.trim();
      return t.isEmpty ? '\n' : line.substring(minIndent);
    }).join('');

    return trimmedLines;
  }

  String red() {
    return '\x1B[31m$this\x1B[0m';
  }

  String green() {
    return '\x1B[32m$this\x1B[0m';
  }
}

String trimIndent(String s) {
  return s.trimIndent();
}
