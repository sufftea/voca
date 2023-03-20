import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:voca/domain/repositories/practice_repository.dart';
import 'package:voca/domain/repositories/words_repository.dart';
import 'package:voca/presentation/entities/word_range.dart';
import 'package:voca/presentation/home/cubit/home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
    this._practiceRepository,
    this._wordsRepository,
  ) : super(const HomeState());

  final PracticeRepository _practiceRepository;
  final WordsRepository _wordsRepository;

  Future<void> onScreenOpened() async {
    final wordsForPractice =
        (await _practiceRepository.createPracticeList()).length;
    final learningListEmpty =
        (await _wordsRepository.fetchLearningWords()).isEmpty;

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
}
