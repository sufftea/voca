import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:voca/domain/domain_constants.dart';
import 'package:voca/domain/entities/dictionary_entry.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/utils/base_styles.dart';
import 'package:voca/presentation/base/widgets/base_card.dart';
import 'package:voca/presentation/practice/widgets/practice_progress_indicator.dart';
import 'package:voca/presentation/word_definition/widgets/word_definitions_widget.dart';

class FlippedCardWidget extends StatelessWidget {
  const FlippedCardWidget({
    required this.card,
    required this.definitions,
    required this.onKnowPressed,
    super.key,
  });

  final VoidCallback onKnowPressed;
  final WordCard card;
  final UnmodifiableListView<WordDefinition>? definitions;

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      child: Column(
        verticalDirection: VerticalDirection.up,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildButtons(context),
          Expanded(child: buildDefinitions()),
          buildHeader(),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BaseStyles.appBarCardDecoration.copyWith(
        color: BaseColors.curiousBlue,
        boxShadow: [
          BoxShadow(
            color: BaseColors.black25,
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            card.word.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeights.bold,
              color: BaseColors.white,
            ),
          ),
          const Spacer(),
          PracticeProgressIndicator(
            currRepetitions: card.repetitionCount,
            totalRepetitions: DomainConstants.maxRepetitionCount,
          ),
        ],
      ),
    );
  }

  Widget buildDefinitions() {
    final definitions = this.definitions;

    if (definitions == null) {
      return buildLoadingDefinitions();
    }

    return WordDefinitionsWidget(
      definitions: definitions,
    );
  }

  Widget buildLoadingDefinitions() {
    return const Placeholder();
  }

  Widget buildButtons(BuildContext context) {
    final t = Translations.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BaseColors.concrete,
        boxShadow: [BoxShadow(blurRadius: 10, color: BaseColors.black25)]
      ),
      child: OutlinedButton(
        onPressed: onKnowPressed,
        child: Text(
          t.practice.knowCheat,
        ),
      ),
    );
  }
}
