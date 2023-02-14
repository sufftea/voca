import 'package:flutter/material.dart';
import 'package:slang/builder/utils/string_extensions.dart';
import 'package:voca/domain/domain_constants.dart';
import 'package:voca/domain/entities/word_card_short.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/widgets/base_card.dart';

class WordListEntry extends StatelessWidget {
  const WordListEntry({
    super.key,
    required this.card,
  });

  final WordCardShort card;

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              card.word.name.capitalize(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeights.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          buildRepetitionCounter(context),
        ],
      ),
    );
  }

  Widget buildRepetitionCounter(BuildContext context) {
    if (card.repetitionCount == 0) {
      return const SizedBox.shrink();
    }

    final t = Translations.of(context);

    if (card.repetitionCount == DomainConstants.maxRepetitionCount) {
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
          const SizedBox(width: 5),
          Container(
            width: 20,
            height: 10,
            decoration: i < card.repetitionCount
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
