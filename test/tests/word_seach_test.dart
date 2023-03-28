import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voca/domain/repositories/words_repository.dart';

import '../injectable/configure_test_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureTestDependencies();

  final wordsRepo = getIt.get<WordsRepository>();

  test('Search results contain the searched word', () async {
    final words = await wordsRepo.findWords('water');
    expect(words.any((card) => card.word.name == 'water'), true);
  });
}
