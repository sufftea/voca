import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/domain/repositories/practice_repository.dart';
import 'package:voca/domain/repositories/user_settings_repository.dart';
import 'package:voca/domain/repositories/words_repository.dart';
import 'package:voca/presentation/home/cubit/home_events.dart';
import 'package:voca/presentation/home/cubit/home_state.dart';
import 'package:voca/presentation/settings/cubit/repetition_count_setting_subject.dart';
import 'package:voca/presentation/cubit_notifiers/word_card_subject.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
    this._practiceRepository,
    this._wordsRepository,
    this._userDataRepository,
    this._wordCardSubject,
    this._countSettingSubject,
  ) : super(const HomeState()) {
    _wordCardSubject.listen(_onWordCardChange);
    _countSettingSubject.listen(_onCardRepetitionChanged);
  }

  final PracticeRepository _practiceRepository;
  final WordsRepository _wordsRepository;
  final UserSettingsRepository _userDataRepository;
  final WordCardSubject _wordCardSubject;
  final RepetitionCountSettingSubject _countSettingSubject;

  final _eventController = StreamController<HomeEvent>.broadcast();
  Stream<HomeEvent> get eventStream => _eventController.stream;

  @override
  Future<void> close () {
    _wordCardSubject.removeListener(_onWordCardChange);
    _countSettingSubject.removeListener(_onCardRepetitionChanged);
    return super.close();
  }

  Future<void> onInitialize() async {
    if (await _userDataRepository.isCrashlyticsCollectionAccepted() == null) {
      _eventController.add(RequestCrashlyticsPermission());
    }

    await _refresh();
  }

  Future<void> onCrashlyticsAccepted({required bool accepted}) async {
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(accepted);
    await _userDataRepository.setCrashlyticsCollectionAccepted(accepted);
  }

  Future<void> _onWordCardChange(WordCard _) async {
    _refresh();
  }

  Future<void> _onCardRepetitionChanged(int _) async {
    _refresh();
  }

  Future<void> _refresh() async {
    final wordsForPractice =
        (await _practiceRepository.createPracticeList()).length;
    final learningListEmpty =
        (await _wordsRepository.fetchLearningList()).isEmpty;

    emit(HomeState(
      wordsForPractice: wordsForPractice,
      learningListEmpty: learningListEmpty,
    ));
  }
}
