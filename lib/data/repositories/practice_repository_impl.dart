import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:voca/data/utils/database_manager.dart';
import 'package:voca/domain/domain_constants.dart';
import 'package:voca/domain/entities/word.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/domain/repositories/practice_repository.dart';

@LazySingleton(as: PracticeRepository)
class PracticeRepositoryImpl implements PracticeRepository {
  const PracticeRepositoryImpl(this._databaseManager);

  final DatabaseManager _databaseManager;

  static const repetitionsToDuration = <int, Duration>{
    0: Duration(days: 1),
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
        DomainConstants.maxRepetitionCount,
      ],
    );

    final cards = _parseCardQuery(qCards);

    // Filter out the cards that are too soon to repeat
    return cards.where(
      (card) {
        if (kDebugMode) {
          return true;
        }

        final diff = DateTime.now().difference(card.lastRepetition!);
        final requiredDiff = repetitionsToDuration[card.repetitionCount]!;

        return diff > requiredDiff;
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
      DateTime.now().millisecondsSinceEpoch,
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
        'lastRepetition': DateTime.now().millisecondsSinceEpoch,
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
      final lastRepetition = DateTime.fromMillisecondsSinceEpoch(
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
