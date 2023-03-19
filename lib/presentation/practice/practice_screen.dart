import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:go_router/go_router.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_consumer.dart';
import 'package:voca/presentation/base/widgets/base_card.dart';
import 'package:voca/presentation/base/widgets/placeholder.dart';
import 'package:voca/presentation/practice/cubit/practice_cubit.dart';
import 'package:voca/presentation/practice/cubit/practice_state.dart';
import 'package:voca/presentation/practice/widgets/card_widget.dart';
import 'package:voca/presentation/practice/widgets/flipped_card_widget.dart';
import 'package:voca/presentation/practice/widgets/practice_results_card_widget.dart';

const _examplesAreaHeight = 120.0;

class SwipeCardData {
  const SwipeCardData({
    required this.card,
    required this.index,
  });

  final WordCard card;
  final int index;
}

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen>
    with StatefulCubitConsumer<PracticeCubit, PracticeState, PracticeScreen> {
  final cardSwiperController = CardSwiperController();

  // For when the action is handled *before* the swipe.
  bool ignoreNextSwipe = false;

  @override
  void initState() {
    super.initState();

    cubit.onScreenOpened();
  }

  void onSwipe() {
    if (ignoreNextSwipe) {
      ignoreNextSwipe = false;
      return;
    }

    if (cubit.state.isFlipped) {
      cubit.onCardUnknown();
    } else {
      cubit.onCardKnown();
    }
  }

  void onGoBack() {
    GoRouter.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          verticalDirection: VerticalDirection.up,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: buildExamplesArea(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: buildCards(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: buildAppBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return SizedBox(
      height: 25,
      child: Center(
        child: builder(
          buildWhen: (prev, curr) =>
              prev.index != curr.index || prev.cards != curr.cards,
          builder: (context, state) {
            final curr = state.index;
            final total = state.cards?.length;

            return Text(
              total == null ? '--/--' : '$curr/$total',
              style: const TextStyle(
                color: BaseColors.curiousBlue,
                fontSize: 20,
                fontWeight: FontWeights.bold,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildResults() {
    return builder(
      buildWhen: (prev, curr) =>
          prev.forgottenWords != curr.forgottenWords ||
          prev.rememberedWords != curr.rememberedWords,
      builder: (context, state) {
        return PracticeResultsCardWidget(
          remembered: state.rememberedWords,
          forgotten: state.forgottenWords,
        );
      },
    );
  }

  Widget buildCards() {
    return builder(
      buildWhen: (prev, curr) => prev.cards != curr.cards,
      builder: (context, state) {
        final cards = state.cards;

        if (cards == null) {
          return buildLoadingCurrCard();
        }

        final cardWidgets = [
          for (var i = 0; i < cards.length; ++i) buildACard(i),
          buildResults(),
        ].reversed.toList();

        return CardSwiper(
          padding: EdgeInsets.zero,
          controller: cardSwiperController,
          cards: cardWidgets,
          onEnd: onGoBack,
          isLoop: false,
          onSwipe: (index, direction) {
            onSwipe();
          },
        );
      },
    );
  }

  Widget buildACard(int index) {
    return builder(
      buildWhen: (prev, curr) =>
          prev.isFlipped != curr.isFlipped || prev.index != curr.index,
      builder: (context, state) {
        if (state.isFlipped && index == state.index) {
          return buildFlippedCard();
        }

        return CardWidget(
          card: state.cards![index],
          onShowDefinition: () {
            cubit.onShowDefinition();
          },
        );
      },
    );
  }

  Widget buildFlippedCard() {
    // Needs rebuild in case the definitions were still loading when the card
    // was flipped. (practically impossible though...)
    return builder(
      buildWhen: (prev, curr) => prev.definitions != curr.definitions,
      builder: (context, state) {
        return FlippedCardWidget(
          card: state.cards![state.index],
          definitions: state.definitions,
          onKnowPressed: () async {
            await cubit.onCardKnown();
            ignoreNextSwipe = true;
            cardSwiperController.swipeTop();
          },
        );
      },
    );
  }

  Widget buildLoadingCurrCard() {
    return BaseCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          PlaceholderCard(
            width: 300,
            height: 25,
          ),
          SizedBox(height: 10),
          PlaceholderCard(
            width: 200,
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget buildRepetitionsCounter() {
    return const Placeholder(
      fallbackHeight: 15,
      fallbackWidth: 200,
    );
  }

  Widget buildExamplesArea() {
    return builder(
      buildWhen: (prev, curr) =>
          prev.definitions != curr.definitions || prev.index != curr.index,
      builder: (context, state) {
        if (state.index == (state.cards?.length ?? 0)) {
          return buildGoBackButton();
        }

        final definitions = state.definitions;

        if (definitions == null) {
          return buildMessageCard('');
        }

        final t = Translations.of(context);

        final examples = [
          for (final definition in definitions) ...definition.examples,
        ];

        if (examples.isEmpty) {
          return buildMessageCard(t.practice.noExamples);
        }

        final cards = <Widget>[
          buildFirstExamplesCard(),
          for (final example in examples) buildExampleCard(example),
        ];

        return LayoutBuilder(builder: (context, cons) {
          return SizedBox(
            height: _examplesAreaHeight,
            width: cons.maxWidth,
            child: Swiper(
              index: 0,
              loop: false,
              viewportFraction: (cons.maxWidth - 40) / cons.maxWidth,
              scale: 0.92,
              itemCount: cards.length,
              itemBuilder: (context, index) => cards[index],
            ),
          );
        });
      },
    );
  }

  Widget buildFirstExamplesCard() {
    final t = Translations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: BaseColors.concrete,
        border: Border.all(color: BaseColors.neptune, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            t.practice.examples,
            style: const TextStyle(
              color: BaseColors.neptune,
            ),
          ),
          const SizedBox(width: 5),
          const Icon(
            Icons.chevron_right,
            color: BaseColors.neptune,
          ),
        ],
      ),
    );
  }

  Widget buildExampleCard(String example) {
    return Container(
      decoration: BoxDecoration(
        color: BaseColors.neptune,
        borderRadius: BorderRadius.circular(5),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        '"$example"',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: BaseColors.white,
        ),
      ),
    );
  }

  Widget buildMessageCard(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: _examplesAreaHeight,
        decoration: BoxDecoration(
          color: BaseColors.concrete,
          border: Border.all(color: BaseColors.neptune, width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: BaseColors.neptune,
          ),
        ),
      ),
    );
  }

  Widget buildGoBackButton() {
    final t = Translations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: _examplesAreaHeight,
        child: FilledButton.icon(
          onPressed: onGoBack,
          icon: const Icon(Icons.arrow_back),
          label: Text(t.practice.goBack),
        ),
      ),
    );
  }
}
