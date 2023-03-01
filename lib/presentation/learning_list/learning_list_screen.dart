import 'package:flutter/material.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/routing/router.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_consumer.dart';
import 'package:voca/presentation/base/utils/go_with_callback.dart';
import 'package:voca/presentation/base/widgets/app_bar_card.dart';
import 'package:voca/presentation/learning_list/cubit/learning_list_cubit.dart';
import 'package:voca/presentation/learning_list/cubit/learning_list_state.dart';
import 'package:voca/presentation/word_search/widgets/word_list_entry.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          buildAppBar(),
          buildBody(),
        ],
      ),
    );
  }

  Widget buildAppBar() {
    final t = Translations.of(context);
    return AppBarCard(
      child: Row(
        children: [
          Text(
            t.learningList.header,
            style: const TextStyle(
              fontWeight: FontWeights.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBody() {
    return builder(
      (context, state) {
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

        return Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            itemCount: words.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: WordListEntry(
                  onTap: (card) {
                    goWithCallback(
                      context,
                      RouteNames.learningList_wordDefinition,
                      onReturn: cubit.refresh,
                      extra: card,
                    );
                  },
                  card: words[index],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget buildMessage(String message) {
    return Text(
      message,
      style: const TextStyle(
        color: BaseColors.neptune,
        fontWeight: FontWeights.bold,
      ),
    );
  }
}
