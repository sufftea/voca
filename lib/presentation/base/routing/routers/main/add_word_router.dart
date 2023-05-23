import 'package:auto_route/auto_route.dart';
import 'package:voca/presentation/base/routing/cubit_route_builder.dart';
import 'package:voca/presentation/base/routing/routers/main/main_router.dart';
import 'package:voca/presentation/word_definition/cubit/word_definition_cubit.dart';
import 'package:voca/presentation/word_search/cubit/search_cubit.dart';

class AddWordRouter extends MainRouter {
  @override
  List<AutoRoute> get routes => [
        CustomRoute(
          initial: true,
          page: WordSearchRoute.page,
          customRouteBuilder: cubitRouteBuilder<SearchCubit>(),
        ),
        CustomRoute(
          page: WordDefinitionRoute.page,
          customRouteBuilder: cubitRouteBuilder<WordDefinitionCubit>(),
        ),
      ];
}
