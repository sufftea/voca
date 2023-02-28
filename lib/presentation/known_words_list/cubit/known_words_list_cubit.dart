import 'dart:collection';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:voca/domain/repositories/words_repository.dart';
import 'package:voca/presentation/known_words_list/cubit/known_words_list_state.dart';

@injectable
class KnownWordsListCubit extends Cubit<KnownWordsListState> {
  KnownWordsListCubit(this._wordsRepository)
      : super(const KnownWordsListState());

  final WordsRepository _wordsRepository;

  Future<void> onScreenOpened() async {
    final words = await _wordsRepository.fetchKnownWords();

    emit(state.copyWith(words: UnmodifiableListView(words)));
  }

  Future<void> refresh() async {
    emit(state.copyWith(words: null));

    final words = await _wordsRepository.fetchKnownWords();

    emit(state.copyWith(words: UnmodifiableListView(words)));
  }
}
