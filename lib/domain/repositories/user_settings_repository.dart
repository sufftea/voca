import 'package:voca/domain/entities/app_theme.dart' as domain;

abstract class UserSettingsRepository {
  Future<void> setRepetitionCount(int n);
  Future<int> getRepetitionCount();

  Future<bool?> isCrashlyticsCollectionAccepted();
  Future<void> setCrashlyticsCollectionAccepted(bool accepted);

  Future<void> setTheme(domain.AppTheme theme);
  Future<domain.AppTheme?> getTheme();
}
