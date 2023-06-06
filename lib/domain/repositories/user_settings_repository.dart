abstract class UserSettingsRepository {
  Future<void> setRepetitionCount(int n);
  Future<int> getRepetitionCount();

  Future<bool?> isCrashlyticsCollectionAccepted();
  Future<void> setCrashlyticsCollectionAccepted(bool accepted);
}
