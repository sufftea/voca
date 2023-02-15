import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slang/builder/utils/string_extensions.dart';
import 'package:voca/domain/entities/word_card_short.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/routing/router.dart';
import 'package:voca/presentation/base/widgets/base_card.dart';
import 'package:voca/presentation/base/widgets/clicable_card.dart';
import 'package:voca/presentation/common_widgets/card_repetition_indicator.dart';

class WordListEntry extends StatelessWidget {
  const WordListEntry({
    super.key,
    required this.card,
  });

  final WordCardShort card;

  @override
  Widget build(BuildContext context) {
    return ClickableCard(
      onTap: () => GoRouter.of(context).pushNamed(
        RouteNames.wordDefinition,
        extra: card,
      ),
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
            buildRepetitionCounter(context),
          ],
        ),
      ),
    );
  }

  Widget buildRepetitionCounter(BuildContext context) {
    return CardRepetitionIndicator(cardData: card.cardData);
  }
}
