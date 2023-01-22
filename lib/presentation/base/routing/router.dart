import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:voca/presentation/base/routing/transitions.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_provider.dart';
import 'package:voca/presentation/home/cubit/home_cubit.dart';
import 'package:voca/presentation/home/home_screen.dart';
import 'package:voca/presentation/nav_bar/cubit/nav_bar_cubit.dart';
import 'package:voca/presentation/nav_bar/nav_bar_shell.dart';
import 'package:voca/presentation/settings/settings_screen.dart';
import 'package:voca/presentation/word_search/cubit/search_cubit.dart';
import 'package:voca/presentation/word_search/word_search_screen.dart';

class RouteNames {
  const RouteNames._();

  static const home = 'home';
  static const wordSearch = 'wordSearch';
  static const settings = 'settings';
}

final _rootKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootKey,
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return cubitProvider<NavBarCubit>(NavBarShell(child: child));
      },
      routes: [
        GoRoute(
          path: '/',
          name: RouteNames.home,
          pageBuilder: (context, state) {
            return fadePageTransition(
              context,
              state,
              cubitProvider<HomeCubit>(const HomeScreen()),
            );
          },
          routes: [
            GoRoute(
              path: 'search',
              name: RouteNames.wordSearch,
              parentNavigatorKey: _rootKey,
              pageBuilder: (context, state) {
                return fadePageTransition(
                  context,
                  state,
                  cubitProvider<SearchCubit>(const WordSearchScreen()),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/settings',
          name: RouteNames.settings,
          pageBuilder: (context, state) {
            return fadePageTransition(
              context,
              state,
              const SettingsScreen(),
            );
          },
        ),
      ],
    ),
  ],
);
