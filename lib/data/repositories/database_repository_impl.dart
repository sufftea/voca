import 'package:injectable/injectable.dart';
import 'package:voca/data/utils/assets_manager.dart';
import 'package:voca/data/utils/database_manager.dart';
import 'package:voca/domain/repositories/database_repository.dart';

@LazySingleton(as: DatabaseRepository)
class DatabaseRepositoryImpl implements DatabaseRepository {
  const DatabaseRepositoryImpl(this._assetsManager, this._databaseManager);

  final AssetsManager _assetsManager;
  final DatabaseManager _databaseManager;

  @override
  Future<void> init() async {
    _assetsManager.createDatabaseFromAssets();
    _databaseManager.init();
  }
}