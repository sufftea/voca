import 'package:voca/domain/entities/word.dart';
import 'package:voca/domain/entities/word_card_user_data.dart';

/// Only the most important info from a word card
class WordCardShort {
  const WordCardShort({
    required this.word,
    required this.userData,
  });

  final Word word;
  final WordCardUserData userData;
}

