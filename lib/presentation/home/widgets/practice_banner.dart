import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/routing/route_names.dart';
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
            const SizedBox(height: 20),
            buildCardsForTodayInfo(),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: cardsForPractice == 0
                  ? null
                  : () {
                      GoRouter.of(context).goNamed(RouteNames.practice);
                    },
              child: Text(t.home.practiceBanner.practice),
            ),
          ] else ...[
            const SizedBox(height: 20),
            Text(
              t.home.practiceBanner.noWordsInLearnList,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeights.semiBold,
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
          fontWeight: FontWeights.bold,
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
            fontWeight: FontWeights.bold,
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
