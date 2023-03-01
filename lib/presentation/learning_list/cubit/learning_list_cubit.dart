import 'dart:collection';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:voca/domain/repositories/words_repository.dart';
import 'package:voca/presentation/learning_list/cubit/learning_list_state.dart';

@injectable
class LearningListCubit extends Cubit<LearningListState> {
  LearningListCubit(
    this._wordsRepository,
  ) : super(const LearningListState());

  final WordsRepository _wordsRepository;

  Future<void> onScreenOpened() async {
    final words = await _wordsRepository.fetchLearningWords();

    emit(state.copyWith(words: UnmodifiableListView(words)));
  }

  Future<void> refresh() async {
    emit(state.copyWith(words: null));

    final words = await _wordsRepository.fetchLearningWords();

    emit(state.copyWith(words: UnmodifiableListView(words)));
  }
}
