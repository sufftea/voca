import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/presentation/base/theming/app_themes.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/routing/routers/main/main_router.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_consumer.dart';
import 'package:voca/presentation/word_search/cubit/search_cubit.dart';
import 'package:voca/presentation/word_search/cubit/search_state.dart';
import 'package:voca/presentation/word_search/widgets/add_word_button.dart';
import 'package:voca/presentation/word_search/widgets/word_search_bar.dart';
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

    initStateAsync();
  }

  Future<void> initStateAsync() async {
    if (widget.initialSearch != null) {
      await cubit.onSearchTextChanged(widget.initialSearch!);
    } else {
      searchBarFocusNode.requestFocus();
    }

    await cubit.onScreenOpened();
  }

  @override
  void dispose() {
    super.dispose();
    searchBarFocusNode.dispose();
  }

  Future<void> openWordDefinition(card) async {
    searchBarFocusNode.unfocus();

    AutoRouter.of(context).root.push(
          WordDefinitionRoute(
            wordCard: card,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
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
          padding: const EdgeInsets.all(16),
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
                    child: WordSearchBar(
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
              child: WordSearchBar(
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
          prev.status != curr.status ||
          prev.results != curr.results ||
          prev.maxRepetitionCount != curr.maxRepetitionCount,
      builder: (context, state) {
        final t = Translations.of(context);
        return switch (state.status) {
          SearchStatus.needsMoreLetters => buildMessage(t.search.enterNLetters),
          SearchStatus.noResults => buildMessage(t.search.noResults),
          SearchStatus.idle => buildSearchResults(state, context, false),
          SearchStatus.loading => buildSearchResults(state, context, true),
        };
      },
    );
  }

  Stack buildSearchResults(
    SearchState state,
    BuildContext context,
    bool loading,
  ) {
    return Stack(
      children: [
        ListView.builder(
          itemCount: state.results.length,
          padding: EdgeInsets.only(
            left: 16,
            top: 70 + MediaQuery.of(context).padding.top,
            bottom: 12,
          ),
          clipBehavior: Clip.none,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
              ),
              child: buildEntry(state, index, context),
            );
          },
        ),
        if (loading) buildLoadingOverlay(),
      ],
    );
  }

  Widget buildLoadingOverlay() {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.background.withOpacity(0.2),
      alignment: Alignment.center,
      child: SizedBox(
        width: 32,
        height: 32,
        child: CircularProgressIndicator(
          color: theme.colorScheme.onBackground,
          strokeWidth: 5,
        ),
      ),
    );
  }

  Widget buildEntry(SearchState state, int index, BuildContext context) {
    final card = state.results[index];

    return SizedBox(
      height: 48,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: WordListEntry(
              card: card,
              searchedWord: state.lastSearch ?? '',
              maxRepetitionCount: state.maxRepetitionCount,
              onTap: openWordDefinition,
            ),
          ),
          AddWordButton(
            onAddWord: () async {
              await cubit.onAddWordToLearning(card.word);
              searchBarFocusNode.unfocus();
            },
            isAdded: card.status == WordCardStatus.learning,
          ),
        ],
      ),
    );
  }

  Widget buildMessage(String message) {
    final theme = Theme.of(context);

    return Positioned(
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 128,
        ),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeights.bold,
            color: theme.colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
