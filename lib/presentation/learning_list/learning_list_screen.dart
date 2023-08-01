import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/presentation/base/theming/app_themes.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/routing/routers/main/main_router.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_consumer.dart';
import 'package:voca/presentation/base/widgets/app_bar_card.dart';
import 'package:voca/presentation/learning_list/cubit/learning_list_cubit.dart';
import 'package:voca/presentation/learning_list/cubit/learning_list_state.dart';
import 'package:voca/presentation/word_search/widgets/word_list_entry.dart';
import 'package:voca/utils/flavors.dart';

@RoutePage()
class LearningListScreen extends StatefulWidget {
  const LearningListScreen({super.key});

  @override
  State<LearningListScreen> createState() => _LearningListScreenState();
}

class _LearningListScreenState extends State<LearningListScreen>
    with
        StatefulCubitConsumer<LearningListCubit, LearningListState,
            LearningListScreen> {
  @override
  void initState() {
    super.initState();

    cubit.onScreenOpened();
  }

  void onListEntryTap(WordCard card) {
    AutoRouter.of(context).push(WordDefinitionRoute(wordCard: card));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        verticalDirection: VerticalDirection.up,
        children: [
          buildBody(),
          buildAppBar(),
        ],
      ),
      floatingActionButton: Flavors.current == Flavors.dev
          ? FilledButton(
              onPressed: () => cubit.debugTest(),
              child: const Text('debug test'),
            )
          : null,
    );
  }

  Widget buildAppBar() {
    final theme = Theme.of(context);
    final t = Translations.of(context);

    return AppBarCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            t.learningList.header,
            style: const TextStyle(
              fontWeight: FontWeights.bold,
              fontSize: 20,
            ),
          ),
          const Spacer(),
          builder(
            buildWhen: (prev, curr) => prev.words?.length != curr.words?.length,
            builder: (context, state) {
              final length = state.words?.length;

              if (length == null) {
                return const SizedBox.shrink();
              }

              return Text(
                length.toString(),
                style: TextStyle(
                  color: theme.colorScheme.primary.withOpacity(0.8),
                  fontWeight: FontWeights.bold,
                  fontSize: 20,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildBody() {
    return Expanded(
      child: builder(
        buildWhen: (prev, curr) =>
            prev.words != curr.words ||
            prev.maxRepetitionCount != curr.maxRepetitionCount,
        builder: (context, state) {
          final words = state.words;
          if (words == null) {
            final t = Translations.of(context);
            return buildMessage(t.common.wait);
          }
    
          if (words.isEmpty) {
            final t = Translations.of(context);
            return buildMessage(
              t.learningList.noWords,
            );
          }
    
          return  ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              itemCount: words.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: SizedBox(
                    height: 48,
                    child: WordListEntry(
                      maxRepetitionCount: state.maxRepetitionCount,
                      onTap: onListEntryTap,
                      card: words[index],
                    ),
                  ),
                );
              },
          );
        },
      ),
    );
  }

  Widget buildMessage(String message) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Text(
        message,
        style: TextStyle(
          color: theme.colorScheme.secondary,
          fontWeight: FontWeights.bold,
        ),
      ),
    );
  }
}
