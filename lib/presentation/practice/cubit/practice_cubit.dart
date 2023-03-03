import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:voca/domain/repositories/practice_repository.dart';
import 'package:voca/presentation/practice/cubit/practice_state.dart';

@injectable
class PracticeCubit extends Cubit<PracticeState> {
  PracticeCubit(
    this._practiceRepository,
  ) : super(const PracticeState());

  final PracticeRepository _practiceRepository;

  Future<void> onScreenOpened() async {
    final list = await _practiceRepository.createPracticeList();
    debugPrint(list.toString());
  }
}
