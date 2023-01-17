import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_provider.dart';
import 'package:voca/presentation/home/cubit/home_cubit.dart';
import 'package:voca/presentation/home/home_screen.dart';
import 'package:voca/presentation/word_search/word_search_screen.dart';

class RouteNames {
  const RouteNames._();

  static const home = 'home';
  static const wordSearch = 'wordSearch';
}

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: RouteNames.home,
      builder: (context, state) {
        return cubitProvider<HomeCubit>(const HomeScreen());
      },
      routes: [
        GoRoute(
          path: 'search',
          name: RouteNames.wordSearch,
          builder: (context, state) {
            return const WordSearchScreen();
          },
        ),
      ],
    ),
  ],
);
