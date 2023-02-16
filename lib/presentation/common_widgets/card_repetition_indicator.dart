import 'package:flutter/material.dart';
import 'package:voca/domain/domain_constants.dart';
import 'package:voca/domain/entities/word_card_meta.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';

class CardRepetitionIndicator extends StatelessWidget {
  const CardRepetitionIndicator({
    required this.cardData,
    super.key,
  });

  final WordCardMeta cardData;

  @override
  Widget build(BuildContext context) {
    if (cardData.repetitionCount == 0) {
      return const SizedBox.shrink();
    }

    final t = Translations.of(context);

    if (cardData.repetitionCount == DomainConstants.maxRepetitionCount) {
      return Text(
        t.search.completed,
        style: const TextStyle(
          color: BaseColors.neptune,
        ),
      );
    }

    return Row(
      children: [
        for (var i = 0; i < DomainConstants.maxRepetitionCount; ++i) ...[
          if (i != 0) const SizedBox(width: 5),
          Container(
            width: 20,
            height: 10,
            decoration: i < cardData.repetitionCount
                ? BoxDecoration(
                    color: BaseColors.curiousBlue,
                    borderRadius: BorderRadius.circular(3))
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: BaseColors.white,
                    border: Border.all(
                      color: BaseColors.curiousBlue,
                      width: 0.5,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                  ),
          ),
        ]
      ],
    );
  }
}
