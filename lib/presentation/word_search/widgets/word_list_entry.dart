import 'package:flutter/material.dart';
import 'package:slang/builder/utils/string_extensions.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/widgets/base_card.dart';
import 'package:voca/presentation/base/widgets/clicable_card.dart';
import 'package:voca/presentation/common_widgets/card_repetition_indicator.dart';

class WordListEntry extends StatelessWidget {
  const WordListEntry({
    super.key,
    required this.onTap,
    required this.card,
  });

  final WordCard card;
  final void Function(WordCard card) onTap;

  @override
  Widget build(BuildContext context) {
    return ClickableCard(
      onTap: () => onTap(card),
      child: BaseCard(
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
            buildLearningIndicator(),
          ],
        ),
      ),
    );
  }

  Widget buildLearningIndicator() {
    switch (card.status) {
      case WordCardStatus.learning:
        return CardRepetitionIndicator(
          repetitionCount: card.repetitionCount,
        );
      case WordCardStatus.known:
        return const Icon(
          Icons.check_box_rounded,
          color: BaseColors.neptune,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
