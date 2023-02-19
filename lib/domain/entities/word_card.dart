// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:voca/domain/entities/dictionary_entry.dart';
import 'package:voca/domain/entities/word_card_user_data.dart';

class WordCard {
  WordCard({
    required this.dictionaryEntry,
    required this.userData,
  });
  
  final DictionaryEntry dictionaryEntry;
  final WordCardUserData userData;

  WordCard copyWith({
    DictionaryEntry? dictionaryEntry,
    WordCardUserData? userData,
  }) {
    return WordCard(
      dictionaryEntry: dictionaryEntry ?? this.dictionaryEntry,
      userData: userData ?? this.userData,
    );
  }
}
