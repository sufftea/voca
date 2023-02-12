import 'package:injectable/injectable.dart';
import 'package:voca/domain/entities/word.dart';
import 'package:voca/domain/repositories/words_repository.dart';

@LazySingleton()
class FindWordsUseCase {
  const FindWordsUseCase(this.dictionaryRepository);

  final WordsRepository dictionaryRepository;

  Future<List<Word>> call(String text) async {
    // Later this should handle the logic with different languages.
    return dictionaryRepository.findWords(text);
  }
}
