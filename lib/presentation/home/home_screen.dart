import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/routing/route_names.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_consumer.dart';
import 'package:voca/presentation/base/utils/route_observer_mixin.dart';
import 'package:voca/presentation/base/widgets/app_bar_card.dart';
import 'package:voca/presentation/base/widgets/placeholder_or.dart';
import 'package:voca/presentation/home/cubit/home_cubit.dart';
import 'package:voca/presentation/home/cubit/home_state.dart';
import 'package:voca/presentation/home/widgets/discover_banner.dart';
import 'package:voca/presentation/home/widgets/practice_banner.dart';
import 'package:voca/presentation/word_search/widgets/my_search_bar.dart';
import 'package:voca/presentation/word_search/widgets/search_bar_hero_data.dart';
import 'package:voca/utils/flavors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with
        StatefulCubitConsumer<HomeCubit, HomeState, HomeScreen>,
        RouteObserverMixin {
  @override
  void onReturnToScreen() {
    cubit.onScreenOpened();
  }

  @override
  void initState() {
    super.initState();

    cubit.onScreenOpened();
  }

  void onSearchBarTap() {
    GoRouter.of(context).goNamed(RouteNames.wordSearch);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        verticalDirection: VerticalDirection.up,
        children: [
          buildBody(),
          buildAppBar(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).goNamed(RouteNames.wordSearch);
        },
        child: const Icon(
          Icons.add_rounded,
          size: 30,
        ),
      ),
    );
  }

  Expanded buildBody() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (Flavors.current == Flavors.dev) ...[
                buildDiscoverBanner(),
                const SizedBox(height: 20),
              ],
              buildPracticeBanner(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDiscoverBanner() {
    return builder(
      buildWhen: (prev, curr) =>
          prev.selectedWordRange != curr.selectedWordRange,
      builder: (context, state) {
        if (state.selectedWordRange == null) {
          return DiscoverBanner.placeholder;
        }

        return DiscoverBanner(wordRange: state.selectedWordRange!);
      },
    );
  }

  Widget buildPracticeBanner() {
    return builder(
      buildWhen: (prev, curr) =>
          prev.wordsForPractice != curr.wordsForPractice ||
          prev.learningListEmpty != curr.learningListEmpty,
      builder: (context, state) {
        if (state.wordsForPractice == null) {
          return PracticeBanner.placeholder;
        }

        return PracticeBanner(
          cardsForPractice: state.wordsForPractice!,
          learningListEmpty: state.learningListEmpty,
        );
      },
    );
  }

  Widget buildAppBar() {
    return Hero(
      tag: SearchBarHeroData.tag,
      child: Material(
        type: MaterialType.transparency,
        child: AppBarCard(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            reverse: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                buildSearchBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAppBarLoading() {
    return const AppBarCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PlaceholderOr(real: MySearchBar()),
        ],
      ),
    );
  }

  Listener buildSearchBar() {
    return Listener(
      onPointerDown: (_) => onSearchBarTap(),
      behavior: HitTestBehavior.opaque,
      child: const AbsorbPointer(
        child: MySearchBar(),
      ),
    );
  }
}
