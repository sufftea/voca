import 'package:injectable/injectable.dart';
import 'package:voca/data/managers/assets_manager/assets_manager_impl.dart';
import 'package:voca/data/managers/database_manager/database_manager.dart';
import 'package:voca/domain/repositories/app_data_repository.dart';
import 'package:voca/injectable/injectable_init.dart';

@LazySingleton(as: AppDataRepository, env: [mainEnv])
class AppDataRepositoryImpl implements AppDataRepository {
  const AppDataRepositoryImpl(this._assetsManager, this._databaseManager);

  final AssetsManagerImpl _assetsManager;
  final DatabaseManager _databaseManager;

  @PostConstruct(preResolve: true)
  @override
  Future<void> init() async {
    await _assetsManager.copyDictionaryDbFromAssets();
    await _databaseManager.init();
  }
}
