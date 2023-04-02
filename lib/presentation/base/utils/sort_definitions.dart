import 'dart:collection';

import 'package:voca/domain/entities/dictionary_entry.dart';

UnmodifiableListView<WordDefinition> sortDefinitions(
  UnmodifiableListView<WordDefinition> definitions,
) {
  final result = List<WordDefinition>.from(definitions)
    ..sort((a, b) => b.frequency - a.frequency);

  return UnmodifiableListView(result);
}
