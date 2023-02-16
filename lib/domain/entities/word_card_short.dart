import 'package:voca/domain/entities/word.dart';
import 'package:voca/domain/entities/word_card_meta.dart';

/// Only the most important info from a word card
class WordCardShort {
  const WordCardShort({
    required this.word,
    this.cardData = const WordCardMeta(
      repetitionCount: 0,
      status: WordCardStatus.unknown,
    ),
  });

  final Word word;
  final WordCardMeta cardData;
}

