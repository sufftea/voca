import 'dart:collection';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/domain/repositories/user_settings_repository.dart';
import 'package:voca/domain/repositories/words_repository.dart';
import 'package:voca/presentation/cubit_notifiers/word_card_subject.dart';
import 'package:voca/presentation/learning_list/cubit/learning_list_state.dart';

final _r = Random();

@injectable
class LearningListCubit extends Cubit<LearningListState> {
  LearningListCubit(
    this._wordsRepository,
    this._settingsRepository,
    this._wordCardSubject,
  ) : super(const LearningListState()) {
    _wordCardSubject.listen(_onWordCardChange);
  }

  final WordsRepository _wordsRepository;
  final UserSettingsRepository _settingsRepository;
  final WordCardSubject _wordCardSubject;

  @override
  Future<void> close() {
    _wordCardSubject.removeListener(_onWordCardChange);
    return super.close();
  }

  Future<void> onScreenOpened() async {
    _refresh();
  }

  /// Used to quickly add words to the list for debugging
  Future<void> debugTest() async {
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

    _refresh();
  }


  Future<void> _refresh() async {
    emit(state.copyWith(words: null));

    final words = await _wordsRepository.fetchLearningList();
    _sortWordsByProgress(words);

    final maxRepetitionCount = await _settingsRepository.getRepetitionCount();

    emit(state.copyWith(
      words: UnmodifiableListView(words),
      maxRepetitionCount: maxRepetitionCount,
    ));
  }

  void _onWordCardChange(WordCard _) {
    _refresh();
  }

  void _sortWordsByProgress(List<WordCard> words) {
    words.sort((a, b) {
      return a.repetitionCount - b.repetitionCount;
    });
  }


}
