import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/routing/router.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_consumer.dart';
import 'package:voca/presentation/base/widgets/app_bar_card.dart';
import 'package:voca/presentation/base/widgets/placeholder_or.dart';
import 'package:voca/presentation/home/cubit/home_cubit.dart';
import 'package:voca/presentation/home/cubit/home_state.dart';
import 'package:voca/presentation/home/widgets/discover_banner.dart';
import 'package:voca/presentation/home/widgets/practice_banner.dart';
import 'package:voca/presentation/word_search/widgets/search_bar.dart';
import 'package:voca/presentation/word_search/widgets/search_bar_hero_data.dart';
import 'package:voca/utils/flavors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with StatefulCubitConsumer<HomeCubit, HomeState, HomeScreen> {
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
      buildWhen: (prev, curr) => prev.selectedLanguage != curr.selectedLanguage,
      builder: (context, state) {
        if (state.selectedLanguage == null) {
          return DiscoverBanner.placeholder;
        }

        return DiscoverBanner(wordRange: state.selectedWordRange!);
      },
    );
  }

  Widget buildPracticeBanner() {
    return builder(
      buildWhen: (prev, curr) =>
          prev.todaysGoal != curr.todaysGoal ||
          prev.todaysGoalCompleted != curr.todaysGoalCompleted,
      builder: (context, state) {
        if (state.todaysGoal == null) {
          return PracticeBanner.placeholder;
        }

        return PracticeBanner(
          todaysGoal: state.todaysGoal!,
          todaysGoalCompleted: state.todaysGoalCompleted!,
        );
      },
    );
  }

  Widget buildAppBar() {
    return builder(
      buildWhen: (prev, curr) => prev.selectedLanguage != curr.selectedLanguage,
      builder: (context, state) {
        if (state.selectedLanguage == null) {
          return buildAppBarLoading();
        }

        return buildAppBarReady(state.selectedLanguage!);
      },
    );
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

  Widget buildAppBarReady(String language) {
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
                buildLanguageButton(language),
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
    final t = Translations.of(context);

    return TextButton(
      onPressed: () {},
      child: Text(
        t.home.languageIs(language: selectedLanguage),
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeights.bold,
        ),
      ),
    );
  }
}
