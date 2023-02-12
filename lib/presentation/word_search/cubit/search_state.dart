// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/domain/repositories/words_repository.dart';

class SearchState {
  const SearchState({
    this.results = const [],
    this.message = SearchStatus.idle,
    this.handle,
  });

  final List<WordCard> results;
  final SearchStatus message;
  final SearchHandle<WordCard>? handle;

  SearchState copyWith({
    List<WordCard>? results,
    SearchStatus? message,
    SearchHandle<WordCard>? handle,
  }) {
    return SearchState(
      results: results ?? this.results,
      message: message ?? this.message,
      handle: handle ?? this.handle,
    );
  }
}

enum SearchStatus {
  needsMoreLetters,
  noResults,
  idle,
  loading,
  canLoadMore,
}
