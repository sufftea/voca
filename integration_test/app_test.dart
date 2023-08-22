import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';
import 'package:voca/domain/entities/word.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/domain/repositories/words_repository.dart';
import 'package:voca/main.dart' as app;
import 'package:voca/presentation/home/widgets/crashlytics_dialog.dart';
import 'package:voca/presentation/settings/widgets/word_lists_banner.dart';
import 'package:voca/presentation/word_definition/word_definition_screen.dart';
import 'package:voca/presentation/word_search/widgets/word_search_bar.dart';

import 'utils/utils.dart';

Future<void> pumpAndSettle(WidgetTester tester) async {
  await Future.delayed(const Duration(seconds: 1));
  await tester.pumpAndSettle();
  return;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Full app test',
    (tester) async {
      app.main();
      await Future.delayed(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // crashlytics dialog
      await testCase(
        "Shows crashlytics dialog upon the first launch",
        () async {
          final dialog = find.byType(CrashlyticsDialog);
          expect(dialog, findsOneWidget);
          await tester.tap(find.byKey(CrashlyticsDialog.acceptKey));
          await pumpAndSettle(tester);
        },
      );

      // Word search
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

      // Adding a word to learning
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
          app.navigatorKey.currentState!.pop(); // from WordDefinitionScreen
          await pumpAndSettle(tester);
          app.navigatorKey.currentState!.pop(); // from WordSearchScreen
          await pumpAndSettle(tester);
          await tester.tap(find.byIcon(Icons.settings));
          await pumpAndSettle(tester);
          await tester.tap(find.byKey(WordListsBanner.learningListButtonKey));
          await pumpAndSettle(tester);
          expect(find.text(randomWord, findRichText: true), findsOneWidget);
          await pumpAndSettle(tester);
        },
      );
    },
  );
}
