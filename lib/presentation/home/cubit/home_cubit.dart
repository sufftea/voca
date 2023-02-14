import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:voca/presentation/base/utils/loading_state/loading_state.dart';
import 'package:voca/presentation/entities/word_range.dart';
import 'package:voca/presentation/home/cubit/home_state.dart';

@injectable
class HomeCubit extends Cubit<LoadingState<HomeState>> {
  HomeCubit() : super(LoadingState.loading());

  Future<void> onScreenOpened() async {
    await Future.delayed(const Duration(seconds: 2));

    emit(LoadingState.ready(HomeState(
      selectedLanguage: 'English',
      nofWordsCurrentlyLearning: 234,
      todaysGoal: 50,
      todaysGoalCompleted: 14,
      selectedWordRange: WordRange(
        low: 7000,
        high: 8000,
        knowNumber: 130,
        learningNumber: 78,
      ),
    )));
  }
}
