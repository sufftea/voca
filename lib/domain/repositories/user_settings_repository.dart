import 'package:voca/domain/entities/app_theme.dart';

abstract class UserSettingsRepository {
  Future<void> setRepetitionCount(int n);
  Future<int> getRepetitionCount();

  Future<bool?> isCrashlyticsCollectionAccepted();
  Future<void> setCrashlyticsCollectionAccepted(bool accepted);

  Future<void> setTheme(AppTheme theme);
  Future<AppTheme> getTheme();
}
