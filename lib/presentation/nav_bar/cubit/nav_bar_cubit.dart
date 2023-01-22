import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:voca/presentation/nav_bar/cubit/nav_bar_state.dart';
import 'package:voca/presentation/nav_bar/nav_bar_shell.dart';

@injectable
class NavBarCubit extends Cubit<NavBarState> {
  NavBarCubit() : super(const NavBarState());

  void setTab(NavBarTab tab) {
    emit(state.copyWith(activeTab: tab));
  }
}
