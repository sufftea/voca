import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:voca/domain/entities/word_range.dart';
import 'package:voca/presentation/base/utils/loading_state/loading_state.dart';
import 'package:voca/presentation/home/cubit/home_state.dart';

@injectable
class HomeCubit extends Cubit<LoadingState<HomeState>> {
  HomeCubit() : super(LoadingState.loading());

  Future<void> startLoading() async {
    await Future.delayed(const Duration(seconds: 1));

    emit(LoadingState.ready(HomeState(
      selectedLanguage: 'English',
      nofWordsCurrentlyLearning: 234,
      todaysGoal: 50,
      wordRange: const WordRange(
        lower: 7000,
        upper: 8000,
        knownWords: 130,
        learningWords: 78,
      ),
    )));
  }
}
