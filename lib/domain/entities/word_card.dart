// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:voca/domain/entities/dictionary_entry.dart';
import 'package:voca/domain/entities/word_card_meta.dart';

class WordCard {
  WordCard({
    required this.dictionaryEntry,
    required this.cardData,
  });
  
  final DictionaryEntry dictionaryEntry;
  final WordCardMeta cardData;

  WordCard copyWith({
    DictionaryEntry? dictionaryEntry,
    WordCardMeta? cardData,
  }) {
    return WordCard(
      dictionaryEntry: dictionaryEntry ?? this.dictionaryEntry,
      cardData: cardData ?? this.cardData,
    );
  }
}
