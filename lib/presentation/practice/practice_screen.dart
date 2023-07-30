import 'dart:math';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/presentation/base/theming/app_themes.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_consumer.dart';
import 'package:voca/presentation/base/widgets/base_card.dart';
import 'package:voca/presentation/base/widgets/placeholder.dart';
import 'package:voca/presentation/practice/cubit/practice_cubit.dart';
import 'package:voca/presentation/practice/cubit/practice_state.dart';
import 'package:voca/presentation/practice/widgets/word_card_front.dart';
import 'package:voca/presentation/practice/widgets/word_card_back.dart';
import 'package:voca/presentation/practice/widgets/practice_results_card_widget.dart';
import 'package:voca/presentation/practice/widgets/word_card_widget.dart';

const _examplesAreaHeight = 120.0;

class SwipeCardData {
  const SwipeCardData({
    required this.card,
    required this.index,
  });

  final WordCard card;
  final int index;
}

@RoutePage()
class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen>
    with
        StatefulCubitConsumer<PracticeCubit, PracticeState, PracticeScreen>,
        TickerProviderStateMixin {
  final cardSwiperController = CardSwiperController();

  /// For when the action (Know/Forgot) is handled before the swipe (when
  /// pressing the Remember button)
  bool ignoreNextSwipe = false;

  late final emojiSlideCtrl = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late final emojiFadeCtrl = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );
  late final slideAnim =
      CurveTween(curve: Curves.easeOutCubic).animate(emojiSlideCtrl);
  late final fadeAnim =
      CurveTween(curve: Curves.easeInOutQuad).animate(emojiFadeCtrl);
  late OverlayEntry swipeResultOverlay;
  bool isEmojiShown = false;
  final cardFlippedNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    cubit.onScreenOpened();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      createEmojiOverlay();
    });
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    swipeResultOverlay.remove();
    emojiSlideCtrl.dispose();
    emojiFadeCtrl.dispose();

    super.dispose();
  }

  void createEmojiOverlay() {
    final theme = Theme.of(context);

    final entry = OverlayEntry(
      builder: (context) {
        return AnimatedBuilder(
          animation: Listenable.merge([emojiSlideCtrl, emojiFadeCtrl]),
          builder: (context, child) {
            return Positioned(
              top: lerpDouble(50, 100, slideAnim.value),
              left: 0,
              right: 0,
              child: Center(
                child: Material(
                  type: MaterialType.transparency,
                  child: Opacity(
                    opacity: min(
                      slideAnim.value,
                      1 - fadeAnim.value,
                    ),
                    child: ValueListenableBuilder(
                      valueListenable: cardFlippedNotifier,
                      builder: (context, cardFlipped, child) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: cardFlipped
                                ? theme.colorScheme.errorContainer
                                : theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            cardFlipped ? '¯\\_(ツ)_/¯' : '٩( ^ᴗ^ )۶',
                            style: TextStyle(
                              fontSize: 20,
                              color: cardFlipped
                                  ? theme.colorScheme.onErrorContainer
                                  : theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      swipeResultOverlay = entry;
      Overlay.of(context).insert(entry);
    });
  }

  void showEmojiResult() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      emojiFadeCtrl.stop(canceled: false);
      emojiFadeCtrl.value = 0;

      emojiSlideCtrl.stop(canceled: false);
      emojiSlideCtrl.forward(from: 0);
    });
  }

  void hideEmojiResult() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      emojiFadeCtrl.forward();
    });
  }

  void showAndHideEmojiResult([bool cardFlipped = false]) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      cardFlippedNotifier.value = cardFlipped;

      emojiFadeCtrl.stop(canceled: false);
      emojiFadeCtrl.value = 0;

      emojiSlideCtrl.stop(canceled: false);
      await emojiSlideCtrl.forward(from: 0);

      emojiFadeCtrl.forward();
    });
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
    AutoRouter.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          verticalDirection: VerticalDirection.up,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: buildExamplesArea(theme),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: buildCards(),
              ),
            ),
            buildAppBar(theme),
          ],
        ),
      ),
    );
  }

  Widget buildAppBar(ThemeData theme) {
    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      // toolbarHeight: 80,

      title: builder(
        buildWhen: (prev, curr) =>
            prev.index != curr.index || prev.cards != curr.cards,
        builder: (context, state) {
          final curr = state.index;
          final total = state.cards?.length;

          return Text(
            total == null ? '--/--' : '$curr/$total',
            style: TextStyle(
              color: theme.colorScheme.onBackground,
              fontSize: 18,
              fontWeight: FontWeights.semiBold,
            ),
          );
        },
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
    return LayoutBuilder(builder: (context, cons) {
      return builder(
        buildWhen: (prev, curr) =>
            prev.cards != curr.cards ||
            prev.maxRepetitionCount != curr.maxRepetitionCount ||
            prev.index != curr.index ||
            prev.isFlipped != curr.isFlipped,
        builder: (context, state) {
          final cards = state.cards;

          if (cards == null || state.maxRepetitionCount == 0) {
            return buildLoadingCurrCard();
          }

          const threshold = 0.2;
          final numberOfCards = cards.length + 1;

          return CardSwiper(
            padding: EdgeInsets.zero,
            controller: cardSwiperController,
            cardsCount: numberOfCards,
            numberOfCardsDisplayed: min(numberOfCards, 3),
            backCardOffset: const Offset(0, 35),
            scale: 0.9,
            threshold: threshold,
            cardBuilder: (
              context,
              index,
              horizontalOffsetPercentage,
              verticalOffsetPercentage,
            ) {
              if (index == state.index && index != cards.length) {
                if (horizontalOffsetPercentage.abs() >= 1 ||
                    verticalOffsetPercentage.abs() >= 1) {
                  if (!isEmojiShown) {
                    isEmojiShown = true;

                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      cardFlippedNotifier.value = state.isFlipped;
                    });
                    showEmojiResult();
                  }
                } else {
                  if (isEmojiShown) {
                    isEmojiShown = false;
                    hideEmojiResult();
                  }
                }
              }

              if (index < cards.length) {
                return buildACard(index);
              } else {
                return buildResults();
              }
            },
            onEnd: onGoBack,
            isLoop: false,
            onSwipeRelease: (accepted) {
              if (accepted) {
                hideEmojiResult();
              }
            },
            onSwipe: (previousIndex, currentIndex, direction) {
              onSwipe();
              return true;
            },
          );
        },
      );
    });
  }

  Widget buildACard(int index) {
    return builder(
      buildWhen: (prev, curr) =>
          prev.isFlipped != curr.isFlipped || prev.index != curr.index,
      builder: (context, state) {
        final frontCard = WordCardFront(
          card: state.cards![index],
          maxRepetitionCount: state.maxRepetitionCount,
          onShowDefinition: () {
            cubit.onShowDefinition();
          },
        );

        if (index != state.index) {
          return frontCard;
        }

        return WordCardWidget(
          flipped: state.isFlipped,
          front: frontCard,
          back: builder(
            buildWhen: (prev, curr) => prev.definitions != curr.definitions,
            builder: (context, state) {
              return WordCardBack(
                card: state.cards![state.index],
                definitions: state.definitions,
                maxRepetitionCount: state.maxRepetitionCount,
                onKnowPressed: () async {
                  await cubit.onCardKnown();
                  ignoreNextSwipe = true;
                  cardSwiperController.swipeTop();

                  showAndHideEmojiResult();
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget buildLoadingCurrCard() {
    return const BaseCard(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PlaceholderCard(
            width: 300,
            height: 25,
          ),
          SizedBox(height: 12),
          PlaceholderCard(
            width: 200,
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget buildExamplesArea(ThemeData theme) {
    return builder(
      buildWhen: (prev, curr) =>
          prev.definitions != curr.definitions || prev.index != curr.index,
      builder: (context, state) {
        if (state.index == (state.cards?.length ?? 0)) {
          return buildGoBackButton();
        }

        final definitions = state.definitions;

        if (definitions == null) {
          return buildMessageCard('', theme);
        }

        final t = Translations.of(context);

        final examples = [
          for (final definition in definitions) ...definition.examples,
        ];

        if (examples.isEmpty) {
          return buildMessageCard(t.practice.noExamples, theme);
        }

        final cards = <Widget>[
          buildFirstExamplesCard(theme),
          for (final example in examples) buildExampleCard(example, theme),
        ];

        return LayoutBuilder(builder: (context, cons) {
          return SizedBox(
            height: _examplesAreaHeight,
            width: cons.maxWidth,
            child: Swiper(
              index: 0,
              loop: false,
              viewportFraction: (cons.maxWidth - 32) / cons.maxWidth,
              scale: 0.92,
              itemCount: cards.length,
              itemBuilder: (context, index) => cards[index],
            ),
          );
        });
      },
    );
  }

  Widget buildFirstExamplesCard(ThemeData theme) {
    final t = Translations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        border: Border.all(color: theme.colorScheme.onSurfaceVariant, width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            t.practice.examples,
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 6),
          Icon(
            Icons.chevron_right,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  Widget buildExampleCard(String example, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        '"$example"',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }

  Widget buildMessageCard(String message, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: _examplesAreaHeight,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant,
          border:
              Border.all(color: theme.colorScheme.onSurfaceVariant, width: 1),
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget buildGoBackButton() {
    final t = Translations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
