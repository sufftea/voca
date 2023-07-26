import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:voca/domain/entities/dictionary_entry.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/presentation/base/theming/app_themes.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
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
    final theme = Theme.of(context);

    return Card(
      child: DefaultTextStyle.merge(
        style: TextStyle(color: theme.colorScheme.onSurface),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildHeader(theme),
            Expanded(child: buildDefinitions()),
            buildButtons(context, theme),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              card.word.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeights.bold,
                color: theme.colorScheme.onPrimary,
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

  Widget buildButtons(BuildContext context, ThemeData theme) {
    final t = Translations.of(context);
    return OutlinedButton(
      onPressed: onKnowPressed,
      style: ButtonStyle(
        overlayColor: MaterialStatePropertyAll(
            theme.colorScheme.primaryContainer.withOpacity(0.1)),
        surfaceTintColor: MaterialStatePropertyAll(
            theme.colorScheme.primaryContainer.withOpacity(0.1)),
        foregroundColor: MaterialStatePropertyAll(theme.colorScheme.onSurface),
        padding: const MaterialStatePropertyAll(EdgeInsets.all(16)),
        // shape: MaterialStatePropertyAll(RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(0),
        // )),
        shape: const MaterialStatePropertyAll(LinearBorder(
          top: LinearBorderEdge(size: 1),
          bottom: LinearBorderEdge(size: 1),
        )),
        side: MaterialStatePropertyAll(BorderSide(
          color: theme.colorScheme.onSurface.withOpacity(0.2),
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