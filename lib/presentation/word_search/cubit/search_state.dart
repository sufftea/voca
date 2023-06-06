import 'package:voca/domain/entities/word_card.dart';

class SearchState {
  const SearchState({
    this.results = const [],
    this.status = SearchStatus.idle,
    this.maxRepetitionCount = 0,
    this.lastSearch,
  });

  final List<WordCard> results;
  final SearchStatus status;
  final int maxRepetitionCount;
  final String? lastSearch;

  SearchState copyWith({
    List<WordCard>? results,
    SearchStatus? status,
    int? maxRepetitionCount,
    String? lastSearch,
  }) {
    return SearchState(
      results: results ?? this.results,
      status: status ?? this.status,
      maxRepetitionCount: maxRepetitionCount ?? this.maxRepetitionCount,
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
