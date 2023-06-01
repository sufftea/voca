import 'dart:collection';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:voca/domain/repositories/practice_repository.dart';
import 'package:voca/domain/repositories/user_settings_repository.dart';
import 'package:voca/domain/repositories/words_repository.dart';
import 'package:voca/presentation/base/utils/sort_definitions.dart';
import 'package:voca/presentation/practice/cubit/practice_state.dart';

final _random = Random();

@injectable
class PracticeCubit extends Cubit<PracticeState> {
  PracticeCubit(
    this._practiceRepository,
    this._wordsRepository,
    this._userSettingsRepository,
  ) : super(const PracticeState());

  final PracticeRepository _practiceRepository;
  final WordsRepository _wordsRepository;
  final UserSettingsRepository _userSettingsRepository;

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
    if (state.index == state.cards!.length) {
      return;
    }

    await _practiceRepository.incrementCard(state.cards![state.index].word);

    emit(state.copyWith(
      index: state.index + 1,
      isFlipped: false,
      rememberedWords: state.rememberedWords + 1,
    ));

    await _loadDefinitions();
  }

  Future<void> onCardUnknown() async {
    await _practiceRepository.resetCard(state.cards![state.index].word);

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
