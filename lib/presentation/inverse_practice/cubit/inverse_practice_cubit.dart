import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:voca/presentation/inverse_practice/cubit/inverse_practice_state.dart';

@injectable
class InversePracticeCubit extends Cubit<InversePracticeState> {
  InversePracticeCubit() : super(const InversePracticeState());
}