import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voca/domain/entities/word_card_short.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/routing/router.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_consumer.dart';
import 'package:voca/presentation/base/widgets/app_bar_card.dart';
import 'package:voca/presentation/word_search/cubit/search_cubit.dart';
import 'package:voca/presentation/word_search/cubit/search_state.dart';
import 'package:voca/presentation/word_search/widgets/search_bar.dart';
import 'package:voca/presentation/word_search/widgets/search_bar_hero_data.dart';
import 'package:voca/presentation/word_search/widgets/word_list_entry.dart';

final k = GlobalKey();

class WordSearchScreen extends StatefulWidget {
  const WordSearchScreen({super.key});

  @override
  State<WordSearchScreen> createState() => _WordSearchScreenState();
}

class _WordSearchScreenState extends State<WordSearchScreen>
    with StatefulCubitConsumer<SearchCubit, SearchState, WordSearchScreen> {
  void onOpenDefinition(WordCardShort card) async {
    final r = GoRouter.of(context);

    final screenLocation = r.location;

    void onReturn() async {
      final r = GoRouter.of(context);
      if (r.location != screenLocation) {
        return;
      }

      r.removeListener(onReturn);
      cubit.refresh();
    }


    r.pushNamed(
      RouteNames.wordDefinition,
      extra: card,
    );

    r.addListener(onReturn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColors.white,
      body: Column(
        verticalDirection: VerticalDirection.up,
        children: [
          buildBody(),
          buildAppBar(),
        ],
      ),
    );
  }

  Widget buildAppBar() {
    return Hero(
      tag: SearchBarHeroData.tag,
      child: Material(
        type: MaterialType.transparency,
        child: AppBarCard(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SearchBar(
              onChanged: cubit.onSearchTextChanged,
              key: k,
              autofocus: true,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBody() {
    return Expanded(
      child: builder(
        (context, state) {
          final s = state.status;

          final t = Translations.of(context);

          if (s == SearchStatus.needsMoreLetters) {
            return buildMessage(t.search.enterNLetters);
          }

          if (s == SearchStatus.noResults) {
            return buildMessage(t.search.noResults);
          }

          return ListView.builder(
            itemCount: state.results.length,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                ),
                child: WordListEntry(
                  card: state.results[index],
                  onTap: onOpenDefinition,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Padding buildMessage(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        message,
        style: const TextStyle(
          fontWeight: FontWeights.bold,
          color: BaseColors.neptune,
        ),
      ),
    );
  }
}
