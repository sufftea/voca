import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_provider.dart';
import 'package:voca/presentation/word_search/cubit/search_cubit.dart';
import 'package:voca/presentation/word_search/word_search_screen.dart';

Page<dynamic> fadePageTransition(context, state) {
  return CustomTransitionPage(
    child: cubitProvider<SearchCubit>(const WordSearchScreen()),
    transitionsBuilder: (
      context,
      animation,
      secondaryAnimation,
      child,
    ) {
      return Opacity(
        opacity: animation.value,
        child: child,
      );
    },
  );
}
