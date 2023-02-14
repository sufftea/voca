// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:voca/domain/entities/word_card_short.dart';

class SearchState {
  const SearchState({
    this.results = const [],
    this.status = SearchStatus.idle,
    this.lastSearch,
  });

  final List<WordCardShort> results;
  final SearchStatus status;
  final String? lastSearch;

  SearchState copyWith({
    List<WordCardShort>? results,
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
