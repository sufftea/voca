import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:voca/domain/use_cases/find_words_use_case.dart';
import 'package:voca/presentation/word_search/cubit/search_state.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {
  SearchCubit(
    this._findWordsUseCase,
  ) : super(const SearchState());

  final FindWordsUseCase _findWordsUseCase;

  Future<void> onSearchTextChanged(String text) async {
    if (text.isEmpty) {
      emit(state.copyWith(
        results: [],
        status: SearchStatus.idle,
        lastSearch: text,
      ));
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
}
