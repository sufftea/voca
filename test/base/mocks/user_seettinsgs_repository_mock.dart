import 'package:injectable/injectable.dart';
import 'package:voca/domain/domain_constants.dart';
import 'package:voca/domain/repositories/user_settings_repository.dart';

import '../../injectable/configure_test_dependencies.dart';

@LazySingleton(as: UserSettingsRepository, env: [testEnv])
class UserSettingsRepositoryImpl extends UserSettingsRepository {
  UserSettingsRepositoryImpl();

  int? _repetitionCount;
  bool? _crashlyticsCollectionAccepted;

  @override
  Future<void> setRepetitionCount(int n) async {
    if (!DomainConstants.cardRepetitionSettingWithinRange(n)) {
      throw RepetitionCountLimitException();
    }

    _repetitionCount = n;
  }

  @override
  Future<int> getRepetitionCount() async {
    if (_repetitionCount case final repetitionCount?) {
      return repetitionCount;
    } else {
      await setRepetitionCount(DomainConstants.defaultCardRepetitionsSetting);
      return DomainConstants.defaultCardRepetitionsSetting;
    }
  }

  @override
  Future<bool?> isCrashlyticsCollectionAccepted() async {
    return _crashlyticsCollectionAccepted;
  }

  @override
  Future<void> setCrashlyticsCollectionAccepted(bool accepted) async {
    _crashlyticsCollectionAccepted = accepted;
  }
}

sealed class UserSettingsException implements Exception {}

class RepetitionCountLimitException extends UserSettingsException {}

class StorageUpdateFailed extends UserSettingsException {}
