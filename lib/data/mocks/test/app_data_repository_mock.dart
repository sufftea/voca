import 'package:injectable/injectable.dart';
import 'package:voca/data/managers/database_manager/database_manager.dart';
import 'package:voca/domain/repositories/app_data_repository.dart';
import 'package:voca/injectable/injectable_init.dart';

@LazySingleton(as: AppDataRepository, env: [InjectableEnv.test])
class AppDataRepositoryMock implements AppDataRepository {
  const AppDataRepositoryMock(
    this._databaseManager,
  );

  final DatabaseManager _databaseManager;

  @PostConstruct(preResolve: true)
  @override
  Future<void> init() async {
    await _databaseManager.init();
  }
}
