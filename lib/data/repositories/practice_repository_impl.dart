import 'package:clock/clock.dart';
import 'package:injectable/injectable.dart';
import 'package:voca/data/managers/database_manager/database_manager.dart';
import 'package:voca/data/utils/card_status.dart';
import 'package:voca/data/utils/days_since_epoch.dart';
import 'package:voca/data/utils/get_repetition_interval.dart';
import 'package:voca/domain/entities/word.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/domain/repositories/practice_repository.dart';
import 'package:voca/domain/repositories/user_settings_repository.dart';

@LazySingleton(as: PracticeRepository)
class PracticeRepositoryImpl implements PracticeRepository {
  const PracticeRepositoryImpl(
    this._databaseManager,
    this._userSettingsRepository,
  );

  final DatabaseManager _databaseManager;
  final UserSettingsRepository _userSettingsRepository;

  @override
  Future<List<WordCard>> createPracticeList() async {
    final db = _databaseManager.db;

    final maxRepetitionCount =
        await _userSettingsRepository.getRepetitionCount();

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
        CardStatus.statusToText[WordCardStatus.learning],
        maxRepetitionCount,
      ],
    );

    final cards = _parseCardQuery(qCards);

    // Filter out the cards that are too soon to repeat
    return cards.where(
      (card) {
        final diff = clock.now().difference(card.lastRepetition!);
        final requiredDiff = getRepetitionInterval(card.repetitionCount);

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
      clock.now().daysSinceEpoch,
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
        'lastRepetition': clock.now().daysSinceEpoch,
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
      final status = CardStatus.textToStatus[row['status'] as String]!;

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
