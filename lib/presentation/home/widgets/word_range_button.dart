import 'package:flutter/material.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/widgets/clicable_card.dart';
import 'package:voca/presentation/entities/word_range.dart';
import 'package:voca/presentation/word_range/widgets/word_range_progress_bar.dart';

class WordRangeButton extends StatelessWidget {
  const WordRangeButton({
    required this.wordRange,
    this.onTap,
    super.key,
  });

  final VoidCallback? onTap;
  final WordRange wordRange;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return ClickableCard(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: BaseColors.curiousBlue,
            strokeAlign: BorderSide.strokeAlignInside,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Text(
              t.home.discoverBanner.nofWordsToUncover(n: wordRange.unknown),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeights.bold,
              ),
            ),
            const SizedBox(height: 10),
            WordRangeProgressBar(wordRange: wordRange),
          ],
        ),
      ),
    );
  }
}
