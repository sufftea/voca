// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:voca/domain/entities/word_card.dart';

class SearchState {
  const SearchState({
    this.results = const [],
    this.status = SearchStatus.idle,
    this.lastSearch,
  });

  final List<WordCard> results;
  final SearchStatus status;
  final String? lastSearch;

  SearchState copyWith({
    List<WordCard>? results,
    SearchStatus? status,
    String? lastSearch,
  }) {
    return SearchState(
      results: results ?? this.results,
      status: status ?? this.status,
      lastSearch: lastSearch ?? this.lastSearch,
    );
  }
}

enum SearchStatus {
  needsMoreLetters,
  noResults,
  idle,
  loading,
}
