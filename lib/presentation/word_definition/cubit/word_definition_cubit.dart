import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:voca/domain/entities/word_card_short.dart';
import 'package:voca/domain/repositories/words_repository.dart';
import 'package:voca/presentation/base/utils/loading_state/loading_state.dart';
import 'package:voca/presentation/word_definition/cubit/word_definition_state.dart';

@injectable
class WordDefinitionCubit extends Cubit<WordDefinitionState> {
  WordDefinitionCubit(
    this._wordsRepository,
  ) : super(const WordDefinitionState());

  final WordsRepository _wordsRepository;

  Future<void> onPageOpened(WordCardShort wordCard) async {
    final card = await _wordsRepository.fetchWordCard(wordCard.word);

    emit(state.copyWith(
      wordCard: LoadingState.ready(card),
    ));
  }
}
