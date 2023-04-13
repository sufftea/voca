import 'package:flutter/material.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_consumer.dart';
import 'package:voca/presentation/base/widgets/app_bar_card.dart';
import 'package:voca/presentation/common_widgets/card_repetition_indicator.dart';
import 'package:voca/presentation/word_definition/cubit/word_definition_cubit.dart';
import 'package:voca/presentation/word_definition/cubit/word_definition_state.dart';
import 'package:voca/presentation/word_definition/widgets/word_definitions_widget.dart';

class WordDefinitionScreen extends StatefulWidget {
  const WordDefinitionScreen({
    required this.wordCard,
    super.key,
  });

  final WordCard wordCard;

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
      buildWhen: (prev, curr) =>
          prev.word != curr.word ||
          prev.repetitionCount != curr.repetitionCount ||
          prev.status != curr.status,
      builder: (context, state) {
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
    );
  }

  Widget buildStatusSettings(WordDefinitionState state) {
    final t = Translations.of(context);

    final isSelected = [false, false];

    switch (state.status) {
      case WordCardStatus.unknown:
        isSelected[0] = true;
        break;
      case WordCardStatus.learning:
        isSelected[1] = true;
        break;
      default:
    }

    // TODO: can I remove the column?
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            const borderWidth = 2.0;
            final width = constraints.biggest.width / 2 - borderWidth * 2;

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
                }
              },
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeights.medium,
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
              ],
            );
          },
        ),
      ],
    );
  }

  Row buildLearningInfo(WordDefinitionState state) {
    final t = Translations.of(context);
    final learningEnabled = state.status == WordCardStatus.learning;
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
      buildWhen: (prev, curr) => prev.definitions != curr.definitions,
      builder: (context, state) {
        final definitions = state.definitions;

        if (definitions == null) {
          return WordDefinitionsWidget.placeholder;
        }

        return WordDefinitionsWidget(definitions: definitions);
      },
    );
  }
}
