import 'package:voca/domain/entities/word_card.dart';

class _WordCardStatusText {
  static const removed = 'removed';
  static const learning = 'learning';
}

class CardStatus {
  const CardStatus._();

  static const statusToText = <WordCardStatus, String>{
    WordCardStatus.learning: _WordCardStatusText.learning,
    WordCardStatus.unknown: _WordCardStatusText.removed,
  };

  static const textToStatus = <String, WordCardStatus>{
    _WordCardStatusText.removed: WordCardStatus.unknown,
    _WordCardStatusText.learning: WordCardStatus.learning,
  };
}
