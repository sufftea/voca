import 'package:flutter/material.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/presentation/base/theming/app_themes.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/practice/widgets/card_progress_indicator_light.dart';

class WordCardFront extends StatelessWidget {
  const WordCardFront({
    required this.card,
    required this.onShowDefinition,
    required this.maxRepetitionCount,
    this.dragging = false,
    super.key,
  });

  final WordCard card;
  final bool dragging;
  final VoidCallback? onShowDefinition;
  final int maxRepetitionCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          buildWord(theme),
          const SizedBox(height: 10),
          buildRepetitionCount(),
          const Spacer(),
          buildDefinitionButton(theme),
        ],
      ),
    );
  }

  Widget buildDefinitionButton(ThemeData theme) {
    return OutlinedButton(
      onPressed: onShowDefinition,
      style: ButtonStyle(
        overlayColor: MaterialStatePropertyAll(
            theme.colorScheme.onPrimary.withOpacity(0.1)),
        surfaceTintColor: MaterialStatePropertyAll(theme.colorScheme.onPrimary),
        foregroundColor: MaterialStatePropertyAll(theme.colorScheme.onPrimary),
        padding: const MaterialStatePropertyAll(EdgeInsets.all(16)),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        )),
        side: MaterialStatePropertyAll(BorderSide(
          color: theme.colorScheme.onPrimary.withOpacity(0.1),
          width: 0.5,
        )),
        textStyle: const MaterialStatePropertyAll(
          TextStyle(
            fontSize: 18,
            fontWeight: FontWeights.regular,
          ),
        ),
      ),
      child: Text(
        t.practice.seeDefinition,
      ),
    );
  }

  Widget buildRepetitionCount() {
    return Center(
      child: Container(
        width: 230,
        alignment: Alignment.center,
        child: CardProgressIndicatorLight(
          currRepetitions: card.repetitionCount,
          maxRepetitionCount: maxRepetitionCount,
        ),
      ),
    );
  }

  Widget buildWord(ThemeData theme) {
    return Center(
      child: Text(
        card.word.name,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontSize: 20,
          fontWeight: FontWeights.bold,
        ),
      ),
    );
  }
}
