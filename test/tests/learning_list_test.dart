import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/domain/repositories/words_repository.dart';
import 'package:voca/injectable/injectable_init.dart';

import '../base/utils/prepare_words.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies(InjectableEnv.test);

  final wordsRepo = getIt.get<WordsRepository>();

  final words = await prepareWords(wordsRepo);
  final word0 = words[0];
  final word1 = words[1];

  test('Adding 2 words to the learning list', () async {
    await wordsRepo.setWordCardStatus(word0, WordCardStatus.learning);
    await wordsRepo.setWordCardStatus(word1, WordCardStatus.learning);

    final learningList = await wordsRepo.fetchLearningList();

    expect(learningList.length == 2, true);
    expect(learningList.any((card) => card.word == word0), true);
    expect(learningList.any((card) => card.word == word1), true);
  });
}
