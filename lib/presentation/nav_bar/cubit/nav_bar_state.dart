// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:voca/presentation/nav_bar/nav_bar_shell.dart';

class NavBarState {
  const NavBarState({
    this.activeTab = NavBarTab.home,
  });

  final NavBarTab activeTab;

  NavBarState copyWith({
    NavBarTab? activeTab,
  }) {
    return NavBarState(
      activeTab: activeTab ?? this.activeTab,
    );
  }
}
