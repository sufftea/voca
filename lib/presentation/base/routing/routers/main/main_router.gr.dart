// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'main_router.dart';

abstract class _$MainRouter extends RootStackRouter {
  // ignore: unused_element
  _$MainRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    WordSearchRoute.name: (routeData) {
      final args = routeData.argsAs<WordSearchRouteArgs>(
          orElse: () => const WordSearchRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WordSearchScreen(
          initialSearch: args.initialSearch,
          key: args.key,
        ),
      );
    },
    LearningListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LearningListScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
    PracticeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PracticeScreen(),
      );
    },
    SettingsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingsScreen(),
      );
    },
    SettingsTabRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingsTabRouterScreen(),
      );
    },
    HomeTabRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeTabRouterScreen(),
      );
    },
    TabBarShellRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TabBarShellScreen(),
      );
    },
    WordDefinitionRoute.name: (routeData) {
      final args = routeData.argsAs<WordDefinitionRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WordDefinitionScreen(
          wordCard: args.wordCard,
          key: args.key,
        ),
      );
    },
  };
}

/// generated route for
/// [WordSearchScreen]
class WordSearchRoute extends PageRouteInfo<WordSearchRouteArgs> {
  WordSearchRoute({
    String? initialSearch,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          WordSearchRoute.name,
          args: WordSearchRouteArgs(
            initialSearch: initialSearch,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'WordSearchRoute';

  static const PageInfo<WordSearchRouteArgs> page =
      PageInfo<WordSearchRouteArgs>(name);
}

class WordSearchRouteArgs {
  const WordSearchRouteArgs({
    this.initialSearch,
    this.key,
  });

  final String? initialSearch;

  final Key? key;

  @override
  String toString() {
    return 'WordSearchRouteArgs{initialSearch: $initialSearch, key: $key}';
  }
}

/// generated route for
/// [LearningListScreen]
class LearningListRoute extends PageRouteInfo<void> {
  const LearningListRoute({List<PageRouteInfo>? children})
      : super(
          LearningListRoute.name,
          initialChildren: children,
        );

  static const String name = 'LearningListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PracticeScreen]
class PracticeRoute extends PageRouteInfo<void> {
  const PracticeRoute({List<PageRouteInfo>? children})
      : super(
          PracticeRoute.name,
          initialChildren: children,
        );

  static const String name = 'PracticeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SettingsScreen]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SettingsTabRouterScreen]
class SettingsTabRoute extends PageRouteInfo<void> {
  const SettingsTabRoute({List<PageRouteInfo>? children})
      : super(
          SettingsTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsTabRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomeTabRouterScreen]
class HomeTabRoute extends PageRouteInfo<void> {
  const HomeTabRoute({List<PageRouteInfo>? children})
      : super(
          HomeTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeTabRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TabBarShellScreen]
class TabBarShellRoute extends PageRouteInfo<void> {
  const TabBarShellRoute({List<PageRouteInfo>? children})
      : super(
          TabBarShellRoute.name,
          initialChildren: children,
        );

  static const String name = 'TabBarShellRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [WordDefinitionScreen]
class WordDefinitionRoute extends PageRouteInfo<WordDefinitionRouteArgs> {
  WordDefinitionRoute({
    required WordCard wordCard,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          WordDefinitionRoute.name,
          args: WordDefinitionRouteArgs(
            wordCard: wordCard,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'WordDefinitionRoute';

  static const PageInfo<WordDefinitionRouteArgs> page =
      PageInfo<WordDefinitionRouteArgs>(name);
}

class WordDefinitionRouteArgs {
  const WordDefinitionRouteArgs({
    required this.wordCard,
    this.key,
  });

  final WordCard wordCard;

  final Key? key;

  @override
  String toString() {
    return 'WordDefinitionRouteArgs{wordCard: $wordCard, key: $key}';
  }
}
