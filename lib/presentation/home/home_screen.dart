import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/routing/routers/main/main_router.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_consumer.dart';
import 'package:voca/presentation/base/widgets/app_bar_card.dart';
import 'package:voca/presentation/base/widgets/placeholder_or.dart';
import 'package:voca/presentation/home/cubit/home_cubit.dart';
import 'package:voca/presentation/home/cubit/home_state.dart';
import 'package:voca/presentation/home/widgets/practice_banner.dart';
import 'package:voca/presentation/word_search/widgets/my_search_bar.dart';
import 'package:voca/presentation/word_search/widgets/search_bar_hero_data.dart';

@RoutePage()
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

  void onOpenSearch() {
    AutoRouter.of(context).push(WordSearchRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SafeArea(child: SizedBox.shrink()),
          buildSearchBar(),
          buildBody(),
        ],
      ),
    );
  }

  Widget buildBody() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildPracticeBanner(),
            ],
          ),
        ),
      ),
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

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Hero(
        tag: SearchBarHeroData.tag,
        child: Material(
          type: MaterialType.transparency,
          child: Listener(
            onPointerDown: (_) => onOpenSearch(),
            behavior: HitTestBehavior.opaque,
            child: const AbsorbPointer(
              child: MySearchBar(),
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
}
