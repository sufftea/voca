import 'dart:collection';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:voca/domain/repositories/practice_repository.dart';
import 'package:voca/domain/repositories/user_settings_repository.dart';
import 'package:voca/domain/repositories/words_repository.dart';
import 'package:voca/presentation/base/utils/sort_definitions.dart';
import 'package:voca/presentation/practice/cubit/practice_state.dart';
import 'package:voca/presentation/cubit_notifiers/word_card_subject.dart';

final _random = Random();

@injectable
class PracticeCubit extends Cubit<PracticeState> {
  PracticeCubit(
    this._practiceRepository,
    this._wordsRepository,
    this._userSettingsRepository,
    this._wordCardSubject,
  ) : super(const PracticeState());

  final PracticeRepository _practiceRepository;
  final WordsRepository _wordsRepository;
  final UserSettingsRepository _userSettingsRepository;
  final WordCardSubject _wordCardSubject;

  Future<void> onScreenOpened() async {
    final cards = await _practiceRepository.createPracticeList();
    cards.shuffle(_random);

    final maxRepetitionCount =
        await _userSettingsRepository.getRepetitionCount();

    emit(state.copyWith(
      cards: UnmodifiableListView(cards),
      maxRepetitionCount: maxRepetitionCount,
    ));

    await _loadDefinitions();
  }

  Future<void> onShowDefinition() async {
    emit(state.copyWith(
      isFlipped: true,
    ));
  }

  Future<void> onCardKnown() async {
    final cards = state.cards;
    if (cards == null) {
      throw StateError('PracticeCubit was not initialized');
    }

    if (state.index == cards.length) {
      return;
    }

    await _practiceRepository.incrementCard(cards[state.index].word);

    _wordCardSubject.add(cards[state.index].copyWith(
      repetitionCount: cards[state.index].repetitionCount + 1,
    ));

    emit(state.copyWith(
      index: state.index + 1,
      isFlipped: false,
      rememberedWords: state.rememberedWords + 1,
    ));

    await _loadDefinitions();
  }

  Future<void> onCardUnknown() async {
    final cards = state.cards;
    if (cards == null) {
      throw StateError('PracticeCubit was not initialized');
    }

    await _practiceRepository.resetCard(cards[state.index].word);

    _wordCardSubject.add(cards[state.index].copyWith(
      repetitionCount: 0,
    ));

    emit(state.copyWith(
      index: state.index + 1,
      isFlipped: false,
      forgottenWords: state.forgottenWords + 1,
    ));

    await _loadDefinitions();
  }

  Future<void> _loadDefinitions() async {
    if (state.index >= (state.cards?.length ?? 0)) {
      return;
    }

    emit(state.copyWith(definitions: null));

    final dictionaryEntry = await _wordsRepository.fetchDictionaryEntry(
      state.cards![state.index].word,
    );

    emit(state.copyWith(
      definitions: sortDefinitions(dictionaryEntry.definitions),
    ));
  }
}
