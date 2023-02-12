import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/domain/repositories/words_repository.dart';
import 'package:voca/domain/use_cases/find_words_use_case.dart';
import 'package:voca/presentation/word_search/cubit/search_state.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._findWordsUseCase) : super(const SearchState());

  final FindWordsUseCase _findWordsUseCase;
  // SearchHandle<WordCard>? _searchHandle;

  Future<void> onSearchTextChanged(String text) async {
    if (text.length < 3) {
      emit(state.copyWith(
        results: [],
        message: SearchStatus.needsMoreLetters,
        handle: null,
      ));
      return;
    }

    var handle = state.handle;
    if (handle == null) {
      handle = await _findWordsUseCase(text);
    } else {
      await handle.close();
      handle = await _findWordsUseCase(text);
    }

    emit(state.copyWith(
      results: [], // can I remove this?
      message: SearchStatus.loading,
      handle: handle,
    ));

    await handle.fetchMore();

    // prevent race condition (hopefully)
    if (handle != state.handle) {
      handle.close();
      return;
    }

    emit(state.copyWith(
      results: handle.results,
      handle: handle,
      message: handle.closed ? SearchStatus.idle : SearchStatus.canLoadMore,
    ));
  }

  Future<void> onLoadMore() async {
    final handle = state.handle;

    if (handle == null) {
      throw StateError(
        '[onLoadMore] must be called only after [onSearchTextChanged] has been called.',
      );
    }

    if (handle.closed) {
      throw StateError('[onLoadMore]: handle is closed.');
    }

    emit(state.copyWith(
      message: SearchStatus.loading,
    ));

    await handle.fetchMore();

    // prevent race condition
    if (handle != state.handle) {
      handle.close();
      return;
    }

    emit(state.copyWith(
      results: handle.results,
      message: handle.closed ? SearchStatus.idle : SearchStatus.canLoadMore,
      handle: handle,
    ));
  }
}
