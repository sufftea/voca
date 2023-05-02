import 'package:flutter/material.dart';
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
    this.searchedWord = '',
  });

  final WordCard card;
  final String searchedWord;
  final void Function(WordCard card) onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ClickableCard(
        onTap: () => onTap(card),
        child: BaseCard(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              buildWord(context),
              const SizedBox(width: 5),
              buildLearningIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Expanded buildWord(BuildContext context) {
    return Expanded(
      child: RichText(
        text: TextSpan(
          children: buildWordSpans(),
          style: DefaultTextStyle.of(context).style.merge(
                const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeights.bold,
                ),
              ),
        ),
      ),
    );
  }

  List<InlineSpan> buildWordSpans() {
    var queryLetter = searchedWord.characters.iterator..moveNext();
    final textSpans = <InlineSpan>[];

    for (final letter in card.word.name.characters) {
      if (letter == queryLetter.current && queryLetter.isNotEmpty) {
        textSpans.add(TextSpan(
          text: letter,
          style: const TextStyle(
            color: BaseColors.curiousBlue,
          ),
        ));

        !queryLetter.moveNext();
      } else {
        textSpans.add(TextSpan(text: letter));
      }
    }

    return textSpans;
  }

  Widget buildLearningIndicator() {
    switch (card.status) {
      case WordCardStatus.learning:
        return CardRepetitionIndicator(
          repetitionCount: card.repetitionCount,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
