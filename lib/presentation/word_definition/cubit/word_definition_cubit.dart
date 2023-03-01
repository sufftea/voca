import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/domain/repositories/words_repository.dart';
import 'package:voca/presentation/word_definition/cubit/word_definition_state.dart';

@injectable
class WordDefinitionCubit extends Cubit<WordDefinitionState> {
  WordDefinitionCubit(
    this._wordsRepository,
  ) : super(const WordDefinitionState());

  final WordsRepository _wordsRepository;

  Future<void> onPageOpened(WordCard wordCard) async {
    emit(state.copyWith(
      repetitionCount: wordCard.repetitionCount,
      status: wordCard.status,
      word: wordCard.word,
    ));

    final dictionaryEntry = await _wordsRepository.fetchDictionaryEntry(wordCard.word);

    emit(state.copyWith(
      definitions: dictionaryEntry.definitions,
    ));
  }

  Future<void> setWordLearning() async {
    assert(state.word != null, "Call onPageOpened first");

    emit(state.copyWith(
      status: null,
    ));

    await _wordsRepository.setWordCardStatus(
      state.word!,
      WordCardStatus.learningOrLearned,
    );

    emit(state.copyWith(
      status: WordCardStatus.learningOrLearned,
    ));
  }

  Future<void> setWordKnown() async {
    assert(state.word != null, 'Call onPageOpened first');

    emit(state.copyWith(
      status: null,
    ));

    await _wordsRepository.setWordCardStatus(
      state.word!,
      WordCardStatus.known,
    );

    emit(state.copyWith(
      status: WordCardStatus.known,
    ));
  }

  Future<void> setWordUnknown() async {
    assert(state.word != null, 'Call onPageOpened first');

    emit(state.copyWith(
      status: null,
    ));

    await _wordsRepository.setWordCardStatus(
      state.word!,
      WordCardStatus.unknown,
    );

    emit(state.copyWith(
      status: WordCardStatus.unknown,
    ));
  }

  Future<void> resetWord() async {
    assert(state.word != null, 'Call onPageOpened first');

    await _wordsRepository.setWordCardRepetitions(state.word!, 0);

    emit(state.copyWith(
      status: WordCardStatus.learningOrLearned,
      repetitionCount: 0,
    ));
  }
}
