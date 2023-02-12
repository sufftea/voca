import 'dart:collection';

class DictionaryEntry {
  DictionaryEntry({
    required this.name,
    required this.definitions,
  });

  final String name;
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
