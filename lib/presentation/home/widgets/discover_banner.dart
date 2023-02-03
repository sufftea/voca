import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/l10n.dart';
import 'package:voca/presentation/base/routing/router.dart';
import 'package:voca/presentation/base/widgets/base_card.dart';
import 'package:voca/presentation/base/widgets/placeholder_or.dart';
import 'package:voca/presentation/entities/word_range.dart';
import 'package:voca/presentation/home/widgets/word_range_button.dart';

class DiscoverBanner extends StatelessWidget {
  const DiscoverBanner({
    required this.wordRange,
    super.key,
  });

  static final placeholder = PlaceholderOr(
      real: DiscoverBanner(
    wordRange: WordRange(
      low: 0,
      high: 0,
      learningNumber: 0,
      knowNumber: 0,
    ),
  ));

  final WordRange wordRange;

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            Intls.current.discoverBannerTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeights.bold,
            ),
          ),
          const SizedBox(height: 20),
          WordRangeButton(
            onTap: () {
              GoRouter.of(context).goNamed(RouteNames.wordRangeList);
            },
            wordRange: wordRange,
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {},
            child: Text(Intls.current.discoverNew),
          ),
        ],
      ),
    );
  }
}
