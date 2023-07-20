import 'package:flutter/material.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/presentation/base/base_theme.dart';
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
    return Container(
      decoration: BoxDecoration(
        color: BaseColors.curiousBlue,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          buildWord(),
          const SizedBox(height: 10),
          buildRepetitionCount(),
          const Spacer(),
          buildDefinitionButton(),
        ],
      ),
    );
  }

  Widget buildDefinitionButton() {
    return OutlinedButton(
      onPressed: onShowDefinition,
      style: ButtonStyle(
        overlayColor: MaterialStatePropertyAll(BaseColors.white10),
        surfaceTintColor: const MaterialStatePropertyAll(BaseColors.white),
        foregroundColor: const MaterialStatePropertyAll(BaseColors.white),
        padding: const MaterialStatePropertyAll(EdgeInsets.all(16)),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        )),
        side: MaterialStatePropertyAll(BorderSide(
          color: BaseColors.white50,
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

  Widget buildWord() {
    return Center(
      child: Text(
        card.word.name,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: BaseColors.white,
          fontSize: 20,
          fontWeight: FontWeights.bold,
        ),
      ),
    );
  }
}
