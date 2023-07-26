import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/presentation/base/theming/app_themes.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_consumer.dart';
import 'package:voca/presentation/base/widgets/app_bar_card.dart';
import 'package:voca/presentation/common_widgets/card_repetition_indicator.dart';
import 'package:voca/presentation/word_definition/cubit/word_definition_cubit.dart';
import 'package:voca/presentation/word_definition/cubit/word_definition_state.dart';
import 'package:voca/presentation/word_definition/widgets/confirm_reset_dialog.dart';
import 'package:voca/presentation/word_definition/widgets/word_definitions_widget.dart';

@RoutePage()
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

  Future<void> onResetPressed() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return const ConfirmResetDialog();
      },
    );

    if (confirmed ?? false) {
      await cubit.resetCard();
    }
  }

  void onCardStatusButtonPressed(int index) {
    switch (index) {
      case 0:
        cubit.setWordUnknown();
        break;
      case 1:
        cubit.setWordLearning();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: DefaultTextStyle.merge(
          style: TextStyle(
            color: theme.colorScheme.onSurface,
          ),
        child: Column(
          verticalDirection: VerticalDirection.up,
          children: [
            Expanded(child: buildBody()),
            buildAppBar(),
          ],
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return builder(
      buildWhen: (prev, curr) =>
          prev.word != curr.word || prev.status != curr.status,
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
              buildLearningInfo(),
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
    final theme = Theme.of(context);
    
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
            const borderWidth = 1.0;
            final width = constraints.biggest.width / 2 - borderWidth * 2;

            return ToggleButtons(
              isSelected: isSelected,
              onPressed: onCardStatusButtonPressed,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeights.medium,
              ),
              borderColor: theme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(5),
              borderWidth: borderWidth,
              color: theme.colorScheme.secondary,
              fillColor: theme.colorScheme.primaryContainer,
              selectedBorderColor: theme.colorScheme.primary,
              constraints: BoxConstraints(minWidth: width, minHeight: 35),
              selectedColor: theme.colorScheme.primary,
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

  Widget buildLearningInfo() {
    return builder(
      buildWhen: (prev, curr) {
        return prev.repetitionCount != curr.repetitionCount ||
            prev.maxRepetitionCount != curr.maxRepetitionCount ||
            prev.status != curr.status;
      },
      builder: (context, state) {
        final learningEnabled = state.status == WordCardStatus.learning;
        final resetEnabled =
            (state.repetitionCount ?? 0) > 0 && learningEnabled;
        return Row(
          children: [
            buildRepetitionIndicator(
              learningEnabled,
              state.repetitionCount!,
              state.maxRepetitionCount,
            ),
            const SizedBox(width: 10),
            buildResetButton(resetEnabled),
          ],
        );
      },
    );
  }

  Widget buildRepetitionIndicator(
    bool learningEnabled,
    int repetitionCount,
    int maxRepetitionCount,
  ) {
    return Expanded(
      child: Opacity(
        opacity: learningEnabled ? 1 : 0.3,
        child: CardRepetitionIndicator(
          repetitionCount: repetitionCount,
          maxRepetitionCount: maxRepetitionCount,
        ),
      ),
    );
  }

  Widget buildResetButton(bool resetEnabled) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    return TextButton(
      onPressed: resetEnabled ? onResetPressed : null,
      style: ButtonStyle(
        foregroundColor: mspResolveWith(
          none: theme.colorScheme.error,
          disabled: theme.colorScheme.errorContainer.withOpacity(0.8),
        ),
        overlayColor: MaterialStatePropertyAll(
          theme.colorScheme.error.withOpacity(0.1),
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
