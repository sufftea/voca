import 'package:voca/domain/entities/dictionary_entry.dart';

/// Maps part of speech tag from the database (as taken from WordNet) to 
/// [PartOfSpeech]
const posMap = {
  'n': PartOfSpeech.noun,
  'v': PartOfSpeech.verb,
  'a': PartOfSpeech.adjective,
  's': PartOfSpeech.adjective,
  'r': PartOfSpeech.adverb,
};