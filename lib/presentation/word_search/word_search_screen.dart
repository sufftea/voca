import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/routing/routers/main/main_router.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_consumer.dart';
import 'package:voca/presentation/word_search/cubit/search_cubit.dart';
import 'package:voca/presentation/word_search/cubit/search_state.dart';
import 'package:voca/presentation/word_search/widgets/add_word_button.dart';
import 'package:voca/presentation/word_search/widgets/my_search_bar.dart';
import 'package:voca/presentation/word_search/widgets/search_bar_hero_data.dart';
import 'package:voca/presentation/word_search/widgets/word_list_entry.dart';

final k = GlobalKey();

@RoutePage()
class WordSearchScreen extends StatefulWidget {
  const WordSearchScreen({
    this.initialSearch,
    super.key,
  });

  final String? initialSearch;

  @override
  State<WordSearchScreen> createState() => _WordSearchScreenState();
}

class _WordSearchScreenState extends State<WordSearchScreen>
    with StatefulCubitConsumer<SearchCubit, SearchState, WordSearchScreen> {
  late final searchBarFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    if (widget.initialSearch != null) {
      cubit.onSearchTextChanged(widget.initialSearch!);
    } else {
      searchBarFocusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    super.dispose();
    searchBarFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColors.white,
      body: Stack(
        children: [
          buildBody(),
          buildSearchBar(),
        ],
      ),
    );
  }

  Widget buildSearchBar() {
    return Positioned(
      top: 0,
      right: 0,
      left: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Hero(
            tag: SearchBarHeroData.tag,
            flightShuttleBuilder: (
              flightContext,
              animation,
              flightDirection,
              fromHeroContext,
              toHeroContext,
            ) {
              return AnimatedBuilder(
                animation: animation,
                builder: (context, _) {
                  return Material(
                    type: MaterialType.transparency,
                    child: MySearchBar(
                      initialValue: widget.initialSearch,
                      key: k,
                      focusNode: searchBarFocusNode,
                      elevation: animation.value,
                    ),
                  );
                },
              );
            },
            child: Material(
              type: MaterialType.transparency,
              child: MySearchBar(
                onChanged: cubit.onSearchTextChanged,
                initialValue: widget.initialSearch,
                key: k,
                focusNode: searchBarFocusNode,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBody() {
    return builder(
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
              padding: EdgeInsets.only(
                left: 20,
                top: 80 + MediaQuery.of(context).padding.top,
                bottom: 10,
              ),
              clipBehavior: Clip.none,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                  ),
                  child: buildEntry(state, index, context),
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
    );
  }

  Widget buildEntry(SearchState state, int index, BuildContext context) {
    final card = state.results[index];

    return Row(
      children: [
        Expanded(
          child: WordListEntry(
            card: card,
            searchedWord: state.lastSearch ?? '',
            onTap: (card) {
              searchBarFocusNode.unfocus();
              AutoRouter.of(context).root.push(
                    WordDefinitionRoute(
                      wordCard: card,
                      onWordStatusChange: (status) {
                        cubit.onWordStatusUpdate(card.word, status);
                      },
                    ),
                  );
            },
          ),
        ),
        builder(
          buildWhen: (prev, curr) => prev.results != curr.results,
          builder: (context, state) {
            return AddWordButton(
              onAddWord: () async {
                await cubit.onAddWord(card.word);
                searchBarFocusNode.unfocus();
              },
              isAdded: card.status == WordCardStatus.learning,
            );
          },
        ),
      ],
    );
  }

  Widget buildMessage(String message) {
    return Positioned(
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 120,
        ),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeights.bold,
            color: BaseColors.neptune,
          ),
        ),
      ),
    );
  }
}
