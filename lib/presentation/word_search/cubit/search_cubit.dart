import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voca/presentation/word_search/cubit/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(const SearchState());
}
