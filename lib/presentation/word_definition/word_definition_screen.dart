import 'package:flutter/material.dart';
import 'package:voca/domain/entities/dictionary_entry.dart';
import 'package:voca/domain/entities/word_card_meta.dart';
import 'package:voca/domain/entities/word_card_short.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_consumer.dart';
import 'package:voca/presentation/base/widgets/app_bar_card.dart';
import 'package:voca/presentation/base/widgets/placeholder.dart';
import 'package:voca/presentation/common_widgets/card_repetition_indicator.dart';
import 'package:voca/presentation/word_definition/cubit/word_definition_cubit.dart';
import 'package:voca/presentation/word_definition/cubit/word_definition_state.dart';

// TODO: should be defined in the language package, not localized
String mapPos(PartOfSpeech pos) {
  switch (pos) {
    case PartOfSpeech.adjective:
      return 'Adjective';
    case PartOfSpeech.adverb:
      return 'Adverb';
    case PartOfSpeech.noun:
      return 'Noun';
    case PartOfSpeech.verb:
      return 'Verb';
  }
}

class WordDefinitionScreen extends StatefulWidget {
  const WordDefinitionScreen({
    required this.wordCard,
    super.key,
  });

  final WordCardShort wordCard;

  @override
  State<WordDefinitionScreen> createState() => _WordDefinitionScreenState();
}

class _WordDefinitionScreenState extends State<WordDefinitionScreen>
    with
        StatefulCubitConsumer<WordDefinitionCubit, WordDefinitionState,
            WordDefinitionScreen> {
  @override
  void initState() {
    super.initState();

    cubit.onPageOpened(widget.wordCard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColors.white,
      body: Column(
        verticalDirection: VerticalDirection.up,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildBody(),
          buildAppBar(),
        ],
      ),
    );
  }

  Widget buildAppBar() {
    final cardStatus = widget.wordCard.cardData.status;

    return AppBarCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.wordCard.word.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeights.bold,
                ),
              ),
              if (cardStatus == WordCardStatus.learningOrLearned)
                const SizedBox(height: 10),
              CardRepetitionIndicator(cardData: widget.wordCard.cardData),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildBody() {
    return builder(
      (context, state) {
        final wordCard = state.wordCard.readyData;
        if (wordCard == null) {
          return buildDefinitionsPlaceholder();
        }

        final posDefinitions = <List<WordDefinition>>[];
        PartOfSpeech? currPos;

        for (final definition in wordCard.dictionaryEntry.definitions) {
          if (definition.pos != currPos) {
            currPos = definition.pos;
            posDefinitions.add([]);
          }

          posDefinitions.last.add(definition);
        }

        return Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final definitions in posDefinitions) ...[
                  buildPosName(definitions),
                  const SizedBox(height: 10),
                  for (var i = 0; i < definitions.length; ++i) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 30,
                          alignment: Alignment.centerRight,
                          child: Text(
                            (i + 1).toString(),
                            style: const TextStyle(
                              fontSize: 19,
                              color: BaseColors.curiousBlue,
                              fontWeight: FontWeights.extraBold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: buildDefinition(definitions[i]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ]
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildPosName(List<WordDefinition> definitions) {
    return Text(
      mapPos(definitions.first.pos),
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeights.bold,
        color: BaseColors.curiousBlue,
      ),
    );
  }

  Widget buildDefinition(WordDefinition definition) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          definition.definition,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeights.regular,
          ),
        ),

        // buildExamples(definition),
        for (final example in definition.examples) ...[
          Text(
            '"$example"',
            style: const TextStyle(
              color: BaseColors.grey,
              fontSize: 15,
              fontWeight: FontWeights.light,
            ),
          ),
        ]
      ],
    );
  }

  Widget buildDefinitionsPlaceholder() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PlaceholderCard(
              width: 100,
              height: 25,
            ),
            const SizedBox(height: 10),
            for (var i = 0; i < 3; ++i) ...[
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: PlaceholderCard(height: 15),
              ),
              const SizedBox(height: 10),
            ]
          ],
        ),
      ),
    );
  }
}
