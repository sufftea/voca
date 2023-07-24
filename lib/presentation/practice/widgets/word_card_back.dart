import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:voca/domain/entities/dictionary_entry.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/utils/base_styles.dart';
import 'package:voca/presentation/practice/widgets/card_progress_indicator_light.dart';
import 'package:voca/presentation/word_definition/widgets/word_definitions_widget.dart';

class WordCardBack extends StatelessWidget {
  const WordCardBack({
    required this.card,
    required this.definitions,
    required this.onKnowPressed,
    required this.maxRepetitionCount,
    super.key,
  });

  final VoidCallback onKnowPressed;
  final WordCard card;
  final int maxRepetitionCount;
  final UnmodifiableListView<WordDefinition>? definitions;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: BaseColors.concrete,
        borderRadius: BorderRadius.circular(5),
      ),
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
          Expanded(
            child: Text(
              card.word.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeights.bold,
                color: BaseColors.white,
              ),
            ),
          ),
          Expanded(
            child: CardProgressIndicatorLight(
              currRepetitions: card.repetitionCount,
              maxRepetitionCount: maxRepetitionCount,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDefinitions() {
    final definitions = this.definitions;

    if (definitions == null) {
      return WordDefinitionsWidget.placeholder;
    }

    return WordDefinitionsWidget(
      definitions: definitions,
    );
  }

  Widget buildButtons(BuildContext context) {
    final t = Translations.of(context);
    return OutlinedButton(
      onPressed: onKnowPressed,
      style: ButtonStyle(
        overlayColor: MaterialStatePropertyAll(BaseColors.curiousBlue10),
        surfaceTintColor: MaterialStatePropertyAll(BaseColors.curiousBlue10),
        foregroundColor: const MaterialStatePropertyAll(BaseColors.black),
        padding: const MaterialStatePropertyAll(EdgeInsets.all(16)),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        )),
        side: MaterialStatePropertyAll(BorderSide(
          color: BaseColors.black25,
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
        t.practice.rememberWord,
      ),
    );
  }
}

/*
TODO: emoticons:

٩( ^ᴗ^ )۶

¯\_(ツ)_/¯


*/