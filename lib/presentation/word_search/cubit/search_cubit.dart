import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:voca/domain/entities/word.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/domain/repositories/words_repository.dart';
import 'package:voca/domain/use_cases/find_words_use_case.dart';
import 'package:voca/presentation/word_search/cubit/search_state.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {
  SearchCubit(
    this._findWordsUseCase,
    this._wordsRepository,
  ) : super(const SearchState());

  final FindWordsUseCase _findWordsUseCase;
  final WordsRepository _wordsRepository;

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

  Future<void> onAddWord(Word word) async {
    await _wordsRepository.setWordCardStatus(word, WordCardStatus.learning);

    await onWordStatusUpdate(word, WordCardStatus.learning);
  }

  Future<void> refresh() async {
    final text = state.lastSearch;

    if (text != null) {
      onSearchTextChanged(text);
    }
  }

  Future<void> onWordStatusUpdate(Word word, [WordCardStatus? newStatus]) async {
    emit(state.copyWith(
      results: state.results
          .map((card) =>
              card.word == word ? card.copyWith(status: newStatus) : card)
          .toList(),
    ));
  }
}
