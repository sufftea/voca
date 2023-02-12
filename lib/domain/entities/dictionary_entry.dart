import 'dart:collection';

import 'package:voca/domain/entities/word.dart';

class DictionaryEntry {
  DictionaryEntry({
    required this.word,
    required this.definitions,
  });

  final Word word;
  final UnmodifiableListView<WordDefinition> definitions;
}

// aka synset in wordnet
class WordDefinition {
  WordDefinition({
    required this.definition,
    required this.examples,
    required this.pos,
  });

  final String definition;
  final PartOfSpeech pos;
  final UnmodifiableListView<String> examples;
}

enum PartOfSpeech {
  noun,
  verb,
  adjective,
  adverb,
}
