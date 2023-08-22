import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voca/domain/repositories/words_repository.dart';
import 'package:voca/injectable/injectable_init.dart';

import '../base/utils/prepare_words.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies(InjectableEnv.test);

  final wordsRepo = getIt.get<WordsRepository>();

  test('Search results contain the searched word', () async {
    final words = await prepareWords(wordsRepo);
  });
}
