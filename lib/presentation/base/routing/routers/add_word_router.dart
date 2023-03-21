
import 'package:go_router/go_router.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/presentation/base/routing/route_names.dart';
import 'package:voca/presentation/base/routing/transitions.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_provider.dart';
import 'package:voca/presentation/word_definition/cubit/word_definition_cubit.dart';
import 'package:voca/presentation/word_definition/word_definition_screen.dart';
import 'package:voca/presentation/word_search/cubit/search_cubit.dart';
import 'package:voca/presentation/word_search/word_search_screen.dart';

GoRouter createAddWordRouter(String searchedWord) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: RouteNames.wordSearch,
        pageBuilder: (context, state) {
          return fadePageTransition(
            context,
            state,
            cubitProvider<SearchCubit>(WordSearchScreen(
              initialSearch: searchedWord,
            )),
          );
        },
        routes: [
          GoRoute(
            path: 'definition',
            name: RouteNames.wordDefinition,
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
    ],
  );
}