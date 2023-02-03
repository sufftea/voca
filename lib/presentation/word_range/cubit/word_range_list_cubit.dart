import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:voca/presentation/base/utils/loading_state/loading_state.dart';
import 'package:voca/presentation/entities/word_range.dart';
import 'package:voca/presentation/word_range/cubit/word_range_list_state.dart';

@injectable
class WordRangeListCubit extends Cubit<LoadingState<WordRrangeListState>> {
  WordRangeListCubit() : super(LoadingState<WordRrangeListState>.loading());

  void startLoading() async {
    await Future.delayed(const Duration(seconds: 1));

    emit(LoadingState.ready(WordRrangeListState(
      selectedRange: WordRange(
        learningNumber: 1233,
        knowNumber: 3000,
        low: 10000,
        high: 25000,
      ),
      ranges: [
        for (var i = 0; i < 20; ++i)
          WordRange(
            learningNumber: 800,
            knowNumber: 130,
            low: i * 5000,
            high: (i + 1) * 5000,
          ),
      ],
    )));
  }

  void onRangeSelectionChanged(int low, int high) {
    final readyState = state.readyData;
    if (readyState == null) return;

    // TODO: calculate learningNumber and knowNumber.
    emit(LoadingState.ready(readyState.copyWith(
      selectedRange: WordRange(
        low: low,
        high: high,
      ),
    )));
  }
}
