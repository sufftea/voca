import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/routing/router.dart';
import 'package:voca/presentation/base/widgets/base_card.dart';

class WordListsBanner extends StatelessWidget {
  const WordListsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            t.settings.words,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeights.bold,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 70,
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
      ),
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
                fontSize: 15,
                fontWeight: FontWeights.bold,
                color: BaseColors.curiousBlue,
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
                fontSize: 15,
                fontWeight: FontWeights.bold,
                color: BaseColors.neptune,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
