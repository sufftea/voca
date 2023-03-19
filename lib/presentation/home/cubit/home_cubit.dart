import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:voca/presentation/entities/word_range.dart';
import 'package:voca/presentation/home/cubit/home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  Future<void> onScreenOpened() async {
    emit(HomeState(
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
    ));
  }
}
