import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/l10n.dart';
import 'package:voca/presentation/base/routing/router.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_consumer.dart';
import 'package:voca/presentation/base/utils/loading_state/loading_state.dart';
import 'package:voca/presentation/base/widgets/app_bar_card.dart';
import 'package:voca/presentation/base/widgets/placeholder_or.dart';
import 'package:voca/presentation/home/cubit/home_cubit.dart';
import 'package:voca/presentation/home/cubit/home_state.dart';
import 'package:voca/presentation/home/widgets/discover_banner.dart';
import 'package:voca/presentation/home/widgets/practice_banner.dart';
import 'package:voca/presentation/word_search/search_bar.dart';
import 'package:voca/presentation/word_search/search_bar_hero_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with StatefulCubitConsumer<HomeCubit, LoadingState<HomeState>, HomeScreen> {
  @override
  void initState() {
    super.initState();

    cubit.startLoading();
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
        children: [
          buildAppBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildDiscoverBanner(),
                    const SizedBox(height: 20),
                    buildPracticeBanner(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDiscoverBanner() {
    return builder(
      (context, state) {
        return state.map(
          loading: (a) => DiscoverBanner.placeholder,
          ready: (a) => DiscoverBanner(wordRange: a.data.selectedWordRange),
          error: (a) => DiscoverBanner.placeholder,
        );
      },
    );
  }

  Widget buildPracticeBanner() {
    return builder((context, state) {
      return state.map(
        loading: (a) => PracticeBanner.placeholder,
        ready: (a) => PracticeBanner(
          todaysGoal: a.data.todaysGoal,
          todaysGoalCompleted: a.data.todaysGoalCompleted,
        ),
        error: (a) => PracticeBanner.placeholder,
      );
    });
  }

  Widget buildAppBar() {
    return builder((context, state) {
      return state.map(
        loading: (a) => buildAppBarLoading(),
        ready: (a) => buildAppBarReady(a.data),
        error: (a) => buildAppBarLoading(),
      );
    });
  }

  Widget buildAppBarLoading() {
    return AppBarCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PlaceholderOr(real: buildLanguageButton('Placeholder text')),
          const SizedBox(height: 20),
          const PlaceholderOr(real: SearchBar()),
        ],
      ),
    );
  }

  Widget buildAppBarReady(HomeState state) {
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
                buildLanguageButton(state.selectedLanguage),
                const SizedBox(height: 20),
                buildSearchBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Listener buildSearchBar() {
    return Listener(
      onPointerDown: (_) => onSearchBarTap(),
      behavior: HitTestBehavior.opaque,
      child: const AbsorbPointer(
        child: SearchBar(),
      ),
    );
  }

  Widget buildLanguageButton(String selectedLanguage) {
    return TextButton(
      onPressed: () {},
      child: Text(
        Intls.current.language(selectedLanguage),
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeights.bold,
        ),
      ),
    );
  }
}
