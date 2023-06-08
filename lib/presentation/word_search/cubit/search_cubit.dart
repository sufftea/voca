import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:voca/domain/entities/word.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/domain/repositories/user_settings_repository.dart';
import 'package:voca/domain/repositories/words_repository.dart';
import 'package:voca/domain/use_cases/find_words_use_case.dart';
import 'package:voca/presentation/cubit_notifiers/word_card_subject.dart';
import 'package:voca/presentation/word_search/cubit/search_state.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {
  SearchCubit(
    this._findWordsUseCase,
    this._wordsRepository,
    this._userSettingsRepository,
    this._wordCardSubject,
  ) : super(const SearchState()) {
    _wordCardSubject.listen(_onWordUpdate);
  }

  final FindWordsUseCase _findWordsUseCase;
  final WordsRepository _wordsRepository;
  final UserSettingsRepository _userSettingsRepository;
  final WordCardSubject _wordCardSubject;

  @override
  Future<void> close() {
    _wordCardSubject.removeListener(_onWordUpdate);
    return super.close();
  }

  Future<void> onScreenOpened() async {
    final maxRepetitionCount =
        await _userSettingsRepository.getRepetitionCount();

    emit(state.copyWith(
      maxRepetitionCount: maxRepetitionCount,
    ));
  }

  Future<void> onSearchTextChanged(String text) async {
    if (text.isEmpty) {
      emit(state.copyWith(
        results: [],
        status: SearchStatus.idle,
        lastSearch: text,
      ));
      return;
    } else if (text.length < 3) {
      emit(state.copyWith(
        results: [],
        status: SearchStatus.needsMoreLetters,
        lastSearch: text,
      ));
      return;
    }

    emit(state.copyWith(
      lastSearch: text,
      status: SearchStatus.loading,
    ));

    final words = await _findWordsUseCase(text);

    // prevent race condition
    if (state.lastSearch != text) {
      return;
    }

    emit(state.copyWith(
      results: words,
      status: words.isEmpty ? SearchStatus.noResults : SearchStatus.idle,
    ));
  }

  Future<void> onAddWordToLearning(Word word) async {
    await _wordsRepository.setWordCardStatus(word, WordCardStatus.learning);

    emit(state.copyWith(
      results: state.results.map((card) {
        return switch (card.word == word) {
          true => card.copyWith(word: word, status: WordCardStatus.learning),
          false => card,
        };
      }).toList(),
    ));

    final newCard = state.results.firstWhere((card) => card.word == word);
    _wordCardSubject.add(newCard);
  }

  Future<void> refreshSearchResults() async {
    final text = state.lastSearch;

    if (text != null) {
      onSearchTextChanged(text);
    }
  }

  Future<void> _onWordUpdate(WordCard newCard) async {
    emit(state.copyWith(
      results: state.results.map((card) {
        return switch (card.word == newCard.word) {
          true => newCard,
          false => card,
        };
      }).toList(),
    ));
  }
}
