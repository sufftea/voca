import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/routing/router.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_consumer.dart';
import 'package:voca/presentation/base/utils/go_with_callback.dart';
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
  void onOpenDefinition(WordCard card) async {
    goWithCallback(
      context,
      RouteNames.wordDefinition,
      onReturn: cubit.refresh,
      extra: card,
    );
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
        buildWhen: (prev, curr) =>
            prev.status != curr.status || prev.results != curr.results,
        builder: (context, state) {
          final s = state.status;

          final t = Translations.of(context);

          if (s == SearchStatus.needsMoreLetters) {
            return buildMessage(t.search.enterNLetters);
          }

          if (s == SearchStatus.noResults) {
            return buildMessage(t.search.noResults);
          }

          return Stack(
            children: [
              ListView.builder(
                itemCount: state.results.length,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
              ),
              if (s == SearchStatus.loading)
                Container(
                  color: BaseColors.white50,
                  alignment: Alignment.center,
                  child: const SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      color: BaseColors.mineShaft,
                      strokeWidth: 5,
                    ),
                  ),
                ),
            ],
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
