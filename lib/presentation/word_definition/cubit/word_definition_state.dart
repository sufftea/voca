import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/presentation/base/utils/loading_state/loading_state.dart';

class WordDefinitionState {
  const WordDefinitionState({
    this.wordCard = const LoadingState<WordCard>.loading(),
  });

  final LoadingState<WordCard> wordCard;

  WordDefinitionState copyWith({
    LoadingState<WordCard>? wordCard,
  }) {
    return WordDefinitionState(
      wordCard: wordCard ?? this.wordCard,
    );
  }
}
