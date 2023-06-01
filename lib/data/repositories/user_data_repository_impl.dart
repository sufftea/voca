import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voca/domain/repositories/user_data_repository.dart';

class _Keys {
  static const crashlyticsCollectionAccepted = 'crashlyticsCollectionAccepted';
}

@LazySingleton(as: UserDataRepository)
class UserDataRepositoryImpl implements UserDataRepository {
  const UserDataRepositoryImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<bool?> isCrashlyticsCollectionAccepted() async {
    return _prefs.getBool(_Keys.crashlyticsCollectionAccepted);
  }

  @override
  Future<void> setCrashlyticsCollectionAccepted(bool accepted)async  {
    await _prefs.setBool(_Keys.crashlyticsCollectionAccepted, accepted);
  }
}
