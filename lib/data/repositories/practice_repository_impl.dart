import 'package:injectable/injectable.dart';
import 'package:voca/data/utils/database_manager.dart';
import 'package:voca/domain/entities/word.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/domain/repositories/practice_repository.dart';

@LazySingleton(as: PracticeRepository)
class PracticeRepositoryImpl implements PracticeRepository {
  const PracticeRepositoryImpl(this._databaseManager);

  final DatabaseManager _databaseManager;

  // TODO: rename
  @override
  Future<List<WordCard>> createPracticeList() {
    // TODO: implement createPracticeList
    throw UnimplementedError();
  }

  @override
  Future<void> incrementCard(Word word) {
    // TODO: implement incrementCard
    throw UnimplementedError();
  }

  @override
  Future<void> resetCard(Word word) {
    // TODO: implement resetCard
    throw UnimplementedError();
  }
}
