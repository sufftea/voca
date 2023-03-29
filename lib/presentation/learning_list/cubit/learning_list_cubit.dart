import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/domain/repositories/words_repository.dart';
import 'package:voca/presentation/learning_list/cubit/learning_list_state.dart';

final _r = Random();

@injectable
class LearningListCubit extends Cubit<LearningListState> {
  LearningListCubit(
    this._wordsRepository,
  ) : super(const LearningListState());

  final WordsRepository _wordsRepository;

  Future<void> onScreenOpened() async {
    final words = await _wordsRepository.fetchLearningList();
    _sortWordsByProgress(words);

    emit(state.copyWith(words: UnmodifiableListView(words)));
  }

  Future<void> refresh() async {
    emit(state.copyWith(words: null));

    final words = await _wordsRepository.fetchLearningList();
    _sortWordsByProgress(words);

    emit(state.copyWith(words: UnmodifiableListView(words)));
  }

  Future<void> debugPopulate() async {
    final cards = await _wordsRepository.findWords('draw');
    debugPrint('debugPopulate: words.length-: ${cards.length}');

    for (final card in cards) {
      await _wordsRepository.setWordCardStatus(
        card.word,
        WordCardStatus.learning,
      );
      await _wordsRepository.setWordCardRepetitions(
        card.word,
        _r.nextInt(7),
      );
    }

    refresh();
  }

  void _sortWordsByProgress(List<WordCard> words) {
    words.sort((a, b) {
      return a.repetitionCount - b.repetitionCount;
    });
  }
}
