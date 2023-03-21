import 'package:injectable/injectable.dart';
import 'package:voca/data/utils/database_manager.dart';
import 'package:voca/data/utils/days_since_epoch.dart';
import 'package:voca/domain/entities/word.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/domain/repositories/practice_repository.dart';
import 'package:voca/utils/global_constants.dart';

@LazySingleton(as: PracticeRepository)
class PracticeRepositoryImpl implements PracticeRepository {
  const PracticeRepositoryImpl(this._databaseManager);

  final DatabaseManager _databaseManager;

  static const repetitionsToDuration = <int, Duration>{
    0: Duration(days: 0),
    1: Duration(days: 1),
    2: Duration(days: 2),
    3: Duration(days: 3),
    4: Duration(days: 5),
    5: Duration(days: 7),
    6: Duration(days: 10),
  };

  @override
  Future<List<WordCard>> createPracticeList() async {
    final db = _databaseManager.db;

    final qCards = await db.query(
      'up.userWords',
      columns: [
        'wordId',
        'word',
        'repetitions',
        'lastRepetition',
        'status',
      ],
      where: 'status = ? AND repetitions < ?',
      whereArgs: [
        DatabaseManager.wordStatusToText[WordCardStatus.learningOrLearned],
        GlobalConstants.maxRepetitionCount,
      ],
    );

    final cards = _parseCardQuery(qCards);

    // Filter out the cards that are too soon to repeat
    return cards.where(
      (card) {
        final diff = DateTime.now().difference(card.lastRepetition!);
        final requiredDiff = repetitionsToDuration[card.repetitionCount]!;

        return diff >= requiredDiff;
      },
    ).toList();
  }

  @override
  Future<void> incrementCard(Word word) async {
    final db = _databaseManager.db;

    final count = await db.rawUpdate('''
      UPDATE up.userWords
      SET repetitions = repetitions + 1,
        lastRepetition = ?
      WHERE wordId = ?
    ''', [
      DateTime.now().daysSinceEpoch,
      word.id,
    ]);

    assert(count == 1);
  }

  @override
  Future<void> resetCard(Word word) async {
    final db = _databaseManager.db;

    final count = await db.update(
      'up.userWords',
      {
        'lastRepetition': DateTime.now().daysSinceEpoch,
        'repetitions': 0,
      },
      where: 'wordId = ?',
      whereArgs: [word.id],
    );

    assert(count == 1);
  }

  List<WordCard> _parseCardQuery(List<Map<String, Object?>> qCards) {
    final cards = <WordCard>[];

    for (final row in qCards) {
      final id = row['wordId'] as int;
      final word = row['word'] as String;
      final repetitions = row['repetitions'] as int;
      final lastRepetition = DateTimeExt.fromDaysSinceEpoch(
        row['lastRepetition'] as int,
      );
      final status = DatabaseManager.textToWordStatus[row['status'] as String]!;

      cards.add(WordCard(
        word: Word(name: word, id: id),
        repetitionCount: repetitions,
        status: status,
        lastRepetition: lastRepetition,
      ));
    }

    return cards;
  }
}
