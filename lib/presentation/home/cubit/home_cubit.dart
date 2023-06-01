import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:voca/domain/repositories/practice_repository.dart';
import 'package:voca/domain/repositories/user_data_repository.dart';
import 'package:voca/domain/repositories/words_repository.dart';
import 'package:voca/presentation/entities/word_range.dart';
import 'package:voca/presentation/home/cubit/home_events.dart';
import 'package:voca/presentation/home/cubit/home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
    this._practiceRepository,
    this._wordsRepository,
    this._userDataRepository,
  ) : super(const HomeState());

  final PracticeRepository _practiceRepository;
  final WordsRepository _wordsRepository;
  final UserDataRepository _userDataRepository;

  final _eventController = StreamController<HomeEvent>.broadcast();
  Stream<HomeEvent> get eventStream => _eventController.stream;

  Future<void> onScreenOpened() async {
    if (await _userDataRepository.isCrashlyticsCollectionAccepted() == null) {
      _eventController.add(RequestCrashlyticsPermission());
    }

    await refresh();
  }

  Future<void> refresh() async {
    final wordsForPractice =
        (await _practiceRepository.createPracticeList()).length;
    final learningListEmpty =
        (await _wordsRepository.fetchLearningList()).isEmpty;

    emit(HomeState(
      wordsForPractice: wordsForPractice,
      learningListEmpty: learningListEmpty,
      nofWordsCurrentlyLearning: 234,
      selectedWordRange: WordRange(
        low: 7000,
        high: 8000,
        knowNumber: 130,
        learningNumber: 78,
      ),
    ));
  }

  Future<void> onCrashlyticsAccepted({required bool accepted}) async {
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(accepted);
    await _userDataRepository.setCrashlyticsCollectionAccepted(accepted);
  }
}
