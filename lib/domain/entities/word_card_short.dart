import 'package:voca/domain/entities/word.dart';
import 'package:voca/domain/entities/word_card_user_data.dart';

/// Only the most important info from a word card
class WordCardShort {
  const WordCardShort({
    required this.word,
    this.userData = const WordCardUserData(
      repetitionCount: 0,
      status: WordCardStatus.unknown,
    ),
  });

  final Word word;
  final WordCardUserData userData;
}

