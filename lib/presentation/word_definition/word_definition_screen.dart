import 'package:flutter/material.dart';
import 'package:voca/domain/entities/dictionary_entry.dart';
import 'package:voca/domain/entities/word_card_user_data.dart';
import 'package:voca/domain/entities/word_card_short.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
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
      body: Column(
        verticalDirection: VerticalDirection.up,
        children: [
          Expanded(child: buildBody()),
          buildAppBar(),
        ],
      ),
    );
  }

  Widget buildAppBar() {
    return builder(
      (context, state) {
        return AppBarCard(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.word!.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeights.bold,
                ),
              ),
              const SizedBox(height: 10),
              buildLearningInfo(state),
              const SizedBox(height: 10),
              buildStatusSettings(state),
            ],
          ),
        );
      },
      buildWhen: (prev, curr) =>
          prev.word != curr.word ||
          prev.repetitionCount != curr.repetitionCount ||
          prev.status != curr.status,
    );
  }

  Widget buildStatusSettings(WordDefinitionState state) {
    final t = Translations.of(context);

    final isSelected = [false, false, false];

    switch (state.status) {
      case WordCardStatus.unknown:
        isSelected[0] = true;
        break;
      case WordCardStatus.learningOrLearned:
        isSelected[1] = true;
        break;
      case WordCardStatus.known:
        isSelected[2] = true;
        break;
      default:
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(builder: (context, constraints) {
          const borderWidth = 2.0;
          final width = constraints.biggest.width / 3 - borderWidth * 2;

          return ToggleButtons(
            isSelected: isSelected,
            onPressed: (index) {
              switch (index) {
                case 0:
                  cubit.setWordUnknown();
                  break;
                case 1:
                  cubit.setWordLearning();
                  break;
                case 2:
                  cubit.setWordKnown();
                  break;
              }
            },
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeights.bold,
            ),
            borderColor: BaseColors.neptune,
            borderRadius: BorderRadius.circular(5),
            borderWidth: borderWidth,
            color: BaseColors.neptune,
            fillColor: BaseColors.curiousBlue10,
            selectedBorderColor: BaseColors.curiousBlue,
            constraints: BoxConstraints(minWidth: width, minHeight: 35),
            selectedColor: BaseColors.curiousBlue,
            children: [
              Text(t.wordDefinition.none),
              Text(t.wordDefinition.learning),
              Text(t.wordDefinition.know),
            ],
          );
        }),
      ],
    );
  }

  Row buildLearningInfo(WordDefinitionState state) {
    final t = Translations.of(context);
    final learningEnabled = state.status == WordCardStatus.learningOrLearned;
    final resetEnabled = (state.repetitionCount ?? 0) > 0 && learningEnabled;

    return Row(
      children: [
        Opacity(
          opacity: learningEnabled ? 1 : 0.3,
          child: CardRepetitionIndicator(
            repetitionCount: state.repetitionCount!,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: resetEnabled ? () => cubit.resetWord() : null,
          style: ButtonStyle(
            foregroundColor: mspResolveWith(
              none: BaseColors.bittersweet,
              disabled: BaseColors.oldRose,
            ),
            overlayColor: MaterialStatePropertyAll(
              BaseColors.bittersweet10,
            ),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            textStyle: const MaterialStatePropertyAll(TextStyle(
              fontSize: 16,
            )),
          ),
          child: Row(
            children: [
              const Icon(Icons.refresh_rounded),
              const SizedBox(width: 5),
              Text(
                t.wordDefinition.reset,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildBody() {
    return builder(
      (context, state) {
        final definitions = state.definitions;
        if (definitions == null) {
          return buildDefinitionsPlaceholder();
        }

        // Create sets of definitions for each part of speech
        final posDefinitions = <List<WordDefinition>>[];

        PartOfSpeech? currPos;
        for (final definition in definitions) {
          if (definition.pos != currPos) {
            currPos = definition.pos;
            posDefinitions.add([]);
          }

          posDefinitions.last.add(definition);
        }

        return SingleChildScrollView(
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
                ...buildDefinitionsForPos(definitions),
              ],
            ],
          ),
        );
      },
      buildWhen: (prev, curr) => prev.definitions != curr.definitions,
    );
  }

  List<Widget> buildDefinitionsForPos(List<WordDefinition> definitions) {
    return [
      for (var i = 0; i < definitions.length; ++i)
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
    ];
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
    return Padding(
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
    );
  }
}
