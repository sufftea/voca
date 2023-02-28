import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:voca/domain/entities/word_card_short.dart';
import 'package:voca/presentation/base/routing/transitions.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_provider.dart';
import 'package:voca/presentation/home/cubit/home_cubit.dart';
import 'package:voca/presentation/home/home_screen.dart';
import 'package:voca/presentation/learning_list/cubit/learning_list_cubit.dart';
import 'package:voca/presentation/learning_list/learning_list_screen.dart';
import 'package:voca/presentation/nav_bar/cubit/nav_bar_cubit.dart';
import 'package:voca/presentation/nav_bar/nav_bar_shell.dart';
import 'package:voca/presentation/settings/settings_screen.dart';
import 'package:voca/presentation/word_definition/cubit/word_definition_cubit.dart';
import 'package:voca/presentation/word_definition/word_definition_screen.dart';
import 'package:voca/presentation/word_range/cubit/word_range_list_cubit.dart';
import 'package:voca/presentation/word_range/word_range_list_screen.dart';
import 'package:voca/presentation/word_search/cubit/search_cubit.dart';
import 'package:voca/presentation/word_search/word_search_screen.dart';

class RouteNames {
  const RouteNames._();

  static const home = 'home';
  static const wordSearch = 'wordSearch';
  static const settings = 'settings';
  static const learningRange = 'learningRange';
  static const wordDefinition = 'wordInfo';
  static const learningList = 'learningList';
  static const learningListWordDefinition = 'learningListDefinition';
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
              routes: [
                GoRoute(
                  path: 'definition',
                  name: RouteNames.wordDefinition,
                  parentNavigatorKey: _rootKey,
                  pageBuilder: (context, state) {
                    final wordCard = state.extra as WordCardShort;

                    return fadePageTransition(
                      context,
                      state,
                      cubitProvider<WordDefinitionCubit>(
                        WordDefinitionScreen(wordCard: wordCard),
                      ),
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              path: 'range',
              name: RouteNames.learningRange,
              parentNavigatorKey: _rootKey,
              pageBuilder: (context, state) {
                return fadePageTransition(
                  context,
                  state,
                  cubitProvider<WordRangeListCubit>(
                      const WordRangeListScreen()),
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
          routes: [
            GoRoute(
              path: 'learningList',
              name: RouteNames.learningList,
              pageBuilder: (context, state) {
                return fadePageTransition(
                  context,
                  state,
                  cubitProvider<LearningListCubit>(const LearningListScreen()),
                );
              },
              routes: [
                GoRoute(
                  path: 'definition',
                  name: RouteNames.learningListWordDefinition,
                  pageBuilder: (context, state) {
                    final wordCard = state.extra as WordCardShort;

                    return fadePageTransition(
                      context,
                      state,
                      cubitProvider<WordDefinitionCubit>(WordDefinitionScreen(
                        wordCard: wordCard,
                      )),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
