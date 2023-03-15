import 'package:flutter/material.dart';
import 'package:voca/domain/domain_constants.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/practice/widgets/practice_progress_indicator.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    required this.card,
    required this.onShowDefinition,
    this.dragging = false,
    super.key,
  });

  final WordCard card;
  final bool dragging;
  final VoidCallback? onShowDefinition;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: BaseColors.curiousBlue,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black26,
          )
        ],
      ),
      alignment: Alignment.center,
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
    return Padding(
      padding: const EdgeInsets.all(20),
      child: FilledButton(
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(BaseColors.white),
          foregroundColor: MaterialStatePropertyAll(BaseColors.curiousBlue),
        ),
        onPressed: onShowDefinition,
        child: Text(
          t.practice.seeDefinition,
        ),
      ),
    );
  }

  Widget buildRepetitionCount() {
    return Center(
      child: PracticeProgressIndicator(
        currRepetitions: card.repetitionCount,
        totalRepetitions: DomainConstants.maxRepetitionCount,
      ),
    );
  }

  Widget buildWord() {
    return Center(
      child: Text(
        card.word.name,
        style: const TextStyle(
          color: BaseColors.white,
          fontSize: 20,
          fontWeight: FontWeights.bold,
        ),
      ),
    );
  }
}
