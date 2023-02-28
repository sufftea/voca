import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/routing/router.dart';

class WordListsButtonsWidget extends StatelessWidget {
  const WordListsButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          t.settings.wordLists,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeights.bold,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildLearningButton(context),
              const SizedBox(width: 10),
              buildKnownListButton(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildLearningButton(BuildContext context) {
    final t = Translations.of(context);

    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          GoRouter.of(context).goNamed(RouteNames.learningList);
        },
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(BaseColors.curiousBlue10),
            alignment: Alignment.center,
            side: const MaterialStatePropertyAll(BorderSide(
              width: 2,
              color: BaseColors.curiousBlue,
            ))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              t.common.learning,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeights.bold,
                color: BaseColors.curiousBlue,
              ),
            ),
            Text(
              t.settings.nWordsInList(n: 100),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeights.regular,
                color: BaseColors.mineShaft,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildKnownListButton(BuildContext context) {
    final t = Translations.of(context);
    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          GoRouter.of(context).goNamed(RouteNames.knownList);
        },
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(BaseColors.neptune10),
            alignment: Alignment.center,
            side: const MaterialStatePropertyAll(BorderSide(
              width: 2,
              color: BaseColors.neptune,
            ))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              t.common.known,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeights.bold,
                color: BaseColors.neptune,
              ),
            ),
            Text(
              t.settings.nWordsInList(n: 123),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeights.regular,
                color: BaseColors.mineShaft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
