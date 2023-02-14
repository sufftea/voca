import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/entities/word_range.dart';

const _progBarHeight = 20.0;

class WordRangeProgressBar extends StatelessWidget {
  const WordRangeProgressBar({
    required this.wordRange,
    this.verboseLabel = true,
    super.key,
  });

  final WordRange wordRange;

  /// `true`: '7K-8K', `false`: '7K'
  final bool verboseLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        buildRangeText(),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            children: [
              buildKnowLearningTexts(context),
              const SizedBox(height: 5),
              buildProgressBar(),
            ],
          ),
        ),
      ],
    );
  }

  Container buildProgressBar() {
    final knowPercent =
        wordRange.amount != 0 ? wordRange.knowNumber / wordRange.amount : 0;
    final learningPercent =
        wordRange.amount != 0 ? wordRange.learningNumber / wordRange.amount : 0;

    return Container(
      height: _progBarHeight,
      decoration: BoxDecoration(
        color: BaseColors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: BaseColors.black25,
          width: 0.5,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: LayoutBuilder(builder: (context, constraints) {
        final w = constraints.maxWidth;

        return Row(
          children: [
            Container(
              color: BaseColors.neptune,
              width: w * knowPercent,
            ),
            const Spacer(),
            Container(
              color: BaseColors.curiousBlue,
              width: w * learningPercent,
            ),
          ],
        );
      }),
    );
  }

  Row buildKnowLearningTexts(BuildContext context) {
    final t = Translations.of(context);

    return Row(
      children: [
        Text(
          t.rangeSelection.knownAmount(n: wordRange.knowNumber),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeights.bold,
            color: BaseColors.neptune,
          ),
        ),
        const Spacer(),
        Text(
          t.rangeSelection.learningAmount(n: wordRange.learningNumber),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeights.bold,
            color: BaseColors.curiousBlue,
          ),
        ),
      ],
    );
  }

  SizedBox buildRangeText() {
    final low = wordRange.low;
    final high = wordRange.high;
    final f = NumberFormat.compact();

    return SizedBox(
      height: 20,
      width: 50,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          verboseLabel ? '${f.format(low)}-${f.format(high)}' : f.format(low),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeights.bold,
          ),
        ),
      ),
    );
  }
}
