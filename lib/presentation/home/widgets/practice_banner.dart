import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/routing/routers/main/main_router.dart';
import 'package:voca/presentation/base/widgets/base_card.dart';
import 'package:voca/presentation/base/widgets/placeholder_or.dart';

class PracticeBanner extends StatelessWidget {
  const PracticeBanner({
    required this.cardsForPractice,
    required this.learningListEmpty,
    super.key,
  });

  static const placeholder = PlaceholderOr(
    real: PracticeBanner(
      cardsForPractice: 0,
      learningListEmpty: false,
    ),
  );

  final bool learningListEmpty;
  final int cardsForPractice;

  void onPracticeButtonPressed(BuildContext context) async {
    await AutoRouter.of(context).root.push(const PracticeRoute());
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return BaseCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            t.home.practiceBanner.header,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeights.bold,
            ),
          ),
          if (!learningListEmpty) ...[
            const SizedBox(height: 15),
            buildCardsForTodayInfo(),
            const SizedBox(height: 15),
            FilledButton(
              onPressed: switch (cardsForPractice) {
                0 => null,
                _ => () => onPracticeButtonPressed(context),
              },
              child: Text(t.home.practiceBanner.practice),
            ),
          ] else ...[
            const SizedBox(height: 15),
            Text(
              t.home.practiceBanner.noWordsInLearnList,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeights.regular,
                color: BaseColors.neptune,
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget buildCardsForTodayInfo() {
    if (cardsForPractice == 0) {
      return Text(
        t.home.practiceBanner.noCardsForToday,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeights.regular,
          color: BaseColors.neptune,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          t.home.practiceBanner.cardsForToday,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeights.regular,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          cardsForPractice.toString(),
          style: const TextStyle(
            fontSize: 15,
            color: BaseColors.curiousBlue,
            fontWeight: FontWeights.bold,
          ),
        ),
      ],
    );
  }
}
