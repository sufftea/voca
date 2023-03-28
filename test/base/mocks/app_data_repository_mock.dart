import 'package:injectable/injectable.dart';
import 'package:voca/data/managers/assets_manager/assets_manager.dart';
import 'package:voca/data/managers/database_manager/database_manager.dart';
import 'package:voca/domain/repositories/app_data_repository.dart';

import '../../injectable/configure_test_dependencies.dart';

@LazySingleton(as: AppDataRepository, env: [testEnv])
class AppDataRepositoryMock implements AppDataRepository {
  const AppDataRepositoryMock(
    this._databaseManager,
    this._assetsManager,
  );

  final DatabaseManager _databaseManager;
  final AssetsManager _assetsManager;

  @PostConstruct(preResolve: true)
  @override
  Future<void> init() async {
    await _assetsManager.copyDictionaryDbFromAssets();
    await _databaseManager.init();
  }
}
