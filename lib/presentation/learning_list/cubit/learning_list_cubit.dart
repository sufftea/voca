import 'dart:collection';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/domain/repositories/user_settings_repository.dart';
import 'package:voca/domain/repositories/words_repository.dart';
import 'package:voca/presentation/learning_list/cubit/learning_list_state.dart';

final _r = Random();

@injectable
class LearningListCubit extends Cubit<LearningListState> {
  LearningListCubit(
    this._wordsRepository,
    this._settingsRepository,
  ) : super(const LearningListState());

  final WordsRepository _wordsRepository;
  final UserSettingsRepository _settingsRepository;

  Future<void> onScreenOpened() async {
    refresh();
  }

  Future<void> refresh() async {
    emit(state.copyWith(words: null));

    final words = await _wordsRepository.fetchLearningList();
    _sortWordsByProgress(words);

    final maxRepetitionCount = await _settingsRepository.getRepetitionCount();

    emit(state.copyWith(
      words: UnmodifiableListView(words),
      maxRepetitionCount: maxRepetitionCount,
    ));
  }

  /// Used to quickly add words to the list for debugging
  Future<void> debugPopulate() async {
    final cards = await _wordsRepository.findWords('draw');

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
