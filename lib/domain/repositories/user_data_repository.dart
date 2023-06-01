abstract class UserDataRepository {
  Future<bool?> isCrashlyticsCollectionAccepted();
  Future<void> setCrashlyticsCollectionAccepted(bool accepted);
}
