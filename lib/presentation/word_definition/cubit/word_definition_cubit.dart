import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/domain/repositories/user_settings_repository.dart';
import 'package:voca/domain/repositories/words_repository.dart';
import 'package:voca/presentation/base/utils/sort_definitions.dart';
import 'package:voca/presentation/cubit_notifiers/word_card_subject.dart';
import 'package:voca/presentation/word_definition/cubit/word_definition_state.dart';

@injectable
class WordDefinitionCubit extends Cubit<WordDefinitionState> {
  WordDefinitionCubit(
    this._wordsRepository,
    this._settingsRepository,
    this._wordCardSubject,
  ) : super(const WordDefinitionState());

  final WordsRepository _wordsRepository;
  final UserSettingsRepository _settingsRepository;
  final WordCardSubject _wordCardSubject;

  Future<void> onPageOpened(WordCard wordCard) async {
    emit(state.copyWith(
      repetitionCount: wordCard.repetitionCount,
      status: wordCard.status,
      word: wordCard.word,
    ));

    final dictionaryEntry =
        await _wordsRepository.fetchDictionaryEntry(wordCard.word);

    final maxRepetitionCount = await _settingsRepository.getRepetitionCount();

    emit(state.copyWith(
      definitions: sortDefinitions(dictionaryEntry.definitions),
      maxRepetitionCount: maxRepetitionCount,
    ));
  }

  Future<void> setWordLearning() async {
    final word = state.word;
    if (word == null) {
      return; // TODO
    }

    emit(state.copyWith(
      status: null,
    ));

    await _wordsRepository.setWordCardStatus(
      word,
      WordCardStatus.learning,
    );

    emit(state.copyWith(
      status: WordCardStatus.learning,
    ));

    if (state.card case final card?) {
      _wordCardSubject.add(card);
    }
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

    if (state.card case final card?) {
      _wordCardSubject.add(card);
    }
  }

  Future<void> resetCard() async {
    final word = state.word;
    if (word == null) {
      return; // TODO
    }

    await _wordsRepository.setWordCardRepetitions(word, 0);

    emit(state.copyWith(
      status: WordCardStatus.learning,
      repetitionCount: 0,
    ));

    if (state.card case final card?) {
      _wordCardSubject.add(card);
    }
  }
}
