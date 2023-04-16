import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/presentation/base/routing/route_names.dart';
import 'package:voca/presentation/base/routing/transitions.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_provider.dart';
import 'package:voca/presentation/home/home_screen.dart';
import 'package:voca/presentation/inverse_practice/cubit/inverse_practice_cubit.dart';
import 'package:voca/presentation/inverse_practice/inverse_practice_screen.dart';
import 'package:voca/presentation/learning_list/cubit/learning_list_cubit.dart';
import 'package:voca/presentation/learning_list/learning_list_screen.dart';
import 'package:voca/presentation/nav_bar/cubit/nav_bar_cubit.dart';
import 'package:voca/presentation/nav_bar/nav_bar_shell.dart';
import 'package:voca/presentation/practice/cubit/practice_cubit.dart';
import 'package:voca/presentation/practice/practice_screen.dart';
import 'package:voca/presentation/settings/settings_screen.dart';
import 'package:voca/presentation/word_definition/cubit/word_definition_cubit.dart';
import 'package:voca/presentation/word_definition/word_definition_screen.dart';
import 'package:voca/presentation/word_search/cubit/search_cubit.dart';
import 'package:voca/presentation/word_search/word_search_screen.dart';

final _rootKey = GlobalKey<NavigatorState>();

GoRouter createMainRouter() {
  return GoRouter(
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
                const HomeScreen(),
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
                      final wordCard = state.extra as WordCard;

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
                path: 'practice',
                name: RouteNames.practice,
                parentNavigatorKey: _rootKey,
                pageBuilder: (context, state) {
                  return fadePageTransition(
                    context,
                    state,
                    cubitProvider<PracticeCubit>(const PracticeScreen()),
                  );
                },
              ),
              GoRoute(
                path: 'inverse',
                name: RouteNames.inversePractice,
                parentNavigatorKey: _rootKey,
                pageBuilder: (context, state) {
                  return fadePageTransition(
                    context,
                    state,
                    cubitProvider<InversePracticeCubit>(
                      const InversePracticeScreen(),
                    ),
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
                    cubitProvider<LearningListCubit>(
                        const LearningListScreen()),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'definition',
                    name: RouteNames.learningList_wordDefinition,
                    pageBuilder: (context, state) {
                      final wordCard = state.extra as WordCard;

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
}
