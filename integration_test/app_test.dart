import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';
import 'package:voca/domain/entities/word.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/domain/repositories/words_repository.dart';
import 'package:voca/main.dart' as app;
import 'package:voca/presentation/home/widgets/crashlytics_dialog.dart';
import 'package:voca/presentation/home/widgets/practice_banner.dart';
import 'package:voca/presentation/learning_list/learning_list_screen.dart';
import 'package:voca/presentation/nav_bar/tab_bar_shell_screen.dart';
import 'package:voca/presentation/practice/practice_screen.dart';
import 'package:voca/presentation/practice/widgets/word_card_front.dart';
import 'package:voca/presentation/settings/widgets/word_lists_banner.dart';
import 'package:voca/presentation/word_definition/word_definition_screen.dart';
import 'package:voca/presentation/word_search/widgets/add_word_button.dart';
import 'package:voca/presentation/word_search/widgets/word_search_bar.dart';
import 'package:voca/presentation/word_search/word_search_screen.dart';

import 'utils/utils.dart';

Future<void> pumpAndSettle(WidgetTester tester) async {
  // await tester.pumpAndSettle();
  // await Future.delayed(const Duration(seconds: 1));
  await tester.pumpAndSettle();
  return;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Full app test',
    (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      await testCase(
        "Shows crashlytics dialog upon the first launch",
        () async {
          final dialog = find.byType(CrashlyticsDialog);
          expect(dialog, findsOneWidget);
          await tester.tap(find.byKey(CrashlyticsDialog.acceptKey));
          await pumpAndSettle(tester);
        },
      );

      const randomWord = 'random';
      final searchedWord = find.text(randomWord, findRichText: true);
      await testCase(
        "Searching for a word yields a match",
        () async {
          await tester.tap(
            find.byKey(WordSearchBar.textFieldKey),
            warnIfMissed: false,
          );
          await pumpAndSettle(tester);
          await tester.enterText(
            find.byKey(WordSearchBar.textFieldKey),
            randomWord.substring(0, 4),
          );
          await pumpAndSettle(tester);
          expect(searchedWord, findsWidgets);
        },
      );

      await testCase(
        "Add word to learning from WordDefinitionScreen",
        () async {
          await tester.tap(searchedWord, warnIfMissed: false);
          await pumpAndSettle(tester);
          expect(find.byType(WordDefinitionScreen), findsOneWidget);
          await tester
              .tap(find.byKey(WordDefinitionScreen.addToLearningButtonKey));
          await pumpAndSettle(tester);

          final learningWords =
              await GetIt.instance.get<WordsRepository>().fetchLearningList();
          final [
            WordCard(
              word: Word(name: wordName),
              repetitionCount: repetitionCount,
              status: status,
            ),
          ] = learningWords;
          expect(wordName, randomWord);
          expect(repetitionCount, 0);
          expect(status, WordCardStatus.learning);
        },
      );

      await testCase(
        "Learning list screen displays the added word",
        () async {
          popCurrentContext(tester, WordDefinitionScreen);
          await pumpAndSettle(tester);
          popCurrentContext(tester, WordSearchScreen);
          await pumpAndSettle(tester);

          await tester.tap(find.byKey(TabBarShellScreen.settingsTabKey));
          await pumpAndSettle(tester);
          await tester.tap(find.byKey(WordListsBanner.learningListButtonKey));
          await pumpAndSettle(tester);
          expect(find.text(randomWord, findRichText: true), findsOneWidget);
          await pumpAndSettle(tester);
        },
      );

      final words = <String>['air', 'water', 'fire', 'earth'];
      await testCase(
        "Add more words to the list",
        () async {
          popCurrentContext(tester, LearningListScreen);
          await pumpAndSettle(tester);

          await tester.tap(find.byKey(TabBarShellScreen.homeTabKey));
          await pumpAndSettle(tester);

          for (final word in words) {
            await tester.tap(
              find.byKey(WordSearchBar.textFieldKey),
              warnIfMissed: false,
            );
            await pumpAndSettle(tester);

            await tester.enterText(
              find.byKey(WordSearchBar.textFieldKey),
              word,
            );
            await pumpAndSettle(tester);

            await tester.tap(find.byType(AddWordButton).first);
            await pumpAndSettle(tester);
          }
        },
      );

      final remembered = <String>{};
      final forgotten = <String>{};
      await testCase(
        "Practice words",
        () async {
          popCurrentContext(tester, WordSearchScreen);
          await pumpAndSettle(tester);

          await tester.tap(find.byKey(PracticeBanner.practiceButtonKey));
          await pumpAndSettle(tester);

          await Future.delayed(const Duration(seconds: 2));

          expect(
            find.byElementPredicate(
              (element) {
                if (element.widget case final Text t) {
                  return t.data == '0/5';
                }
                return false;
              },
            ),
            findsOneWidget,
          );

          final cardController =
              tester.widget<CardSwiper>(find.byType(CardSwiper)).controller!;

          for (int i = 0; i < 2; ++i) {
            final currWord = tester
                .widget<Text>(find.descendant(
                  of: find.byKey(PracticeScreen.currentCardKey),
                  matching: find.byKey(WordCardFront.wordTextKey),
                ))
                .data!;

            remembered.add(currWord);
            cardController.swipe();
            await pumpAndSettle(tester);
          }

          for (int i = 0; i < 3; ++i) {
            final currWord = tester
                .widget<Text>(find.descendant(
                  of: find.byKey(PracticeScreen.currentCardKey),
                  matching: find.byKey(WordCardFront.wordTextKey),
                ))
                .data!;

            forgotten.add(currWord);

            await tester.tap(find.descendant(
              of: find.byKey(PracticeScreen.currentCardKey),
              matching: find.byKey(WordCardFront.seeDefinitionKey),
            ));
            await pumpAndSettle(tester);

            cardController.swipe();
            await pumpAndSettle(tester);
          }

          await pumpAndSettle(tester);
          await pumpAndSettle(tester);
          await pumpAndSettle(tester);
          await pumpAndSettle(tester);
        },
      );
    },
  );
}
