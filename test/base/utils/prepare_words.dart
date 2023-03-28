import 'package:voca/domain/entities/word.dart';
import 'package:voca/domain/repositories/words_repository.dart';

Future<List<Word>> prepareWords(WordsRepository wordsRepo) async {
  final words = <Word>[];
  
  words.add(await _fetchWordByName('water', wordsRepo));
  words.add(await _fetchWordByName('fire', wordsRepo));
  words.add(await _fetchWordByName('earth', wordsRepo));
  words.add(await _fetchWordByName('air', wordsRepo));

  return words;
}

Future<Word> _fetchWordByName(
  String wordName,
  WordsRepository wordsRepo,
) async {
  final words = await wordsRepo.findWords(wordName);

  return words.firstWhere((card) {
    return card.word.name.toLowerCase() == wordName.toLowerCase();
  }).word;
}
