import 'dart:collection';

import 'package:voca/domain/entities/word_card.dart';

abstract class WordsRepository {
  Future<SearchHandle<WordCard>> findWords(String word);
}

abstract class SearchHandle<T> {
  UnmodifiableListView<T> get results;
  bool get closed;

  /// true - has more data left; false - nothing is left
  Future<bool> fetchMore([int n]);

  /// true - has more data left; false - nothing is left
  Future<bool> fetchAll();

  Future<void> close();
}