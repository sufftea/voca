import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:voca/presentation/notifications/practice_reminder_notification_controller.dart';
import 'package:voca/utils/flavors.dart';

@lazySingleton
class NotificationsManager {
  final practiceReminderController =
      const PracticeReminderNotificationController();

  /// don't use until init was called 
  bool get initSuccess => _initSuccess;
  bool get practiceReminderEnabled => _activeNotificationIds
      .contains(PracticeReminderNotificationController.channelKey);

  late Set<String> _activeNotificationIds;
  late bool _initSuccess;

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    final success = await AwesomeNotifications().initialize(
      null,
      [
        PracticeReminderNotificationController.channel,
      ],
      debug: Flavors.current == Flavors.dev ? true : false,
    );
    await updateEnabledNotifications();

    _initSuccess = success;
  }

  Future<void> updateEnabledNotifications() async {
    final notifs = await AwesomeNotifications().listScheduledNotifications();
    _activeNotificationIds = Set.from(notifs.map((e) => e.content?.channelKey));
  }

  Future<bool> requestPermissions() async {
    final allowed = await AwesomeNotifications().isNotificationAllowed();

    if (allowed) {
      return true;
    }

    return await AwesomeNotifications().requestPermissionToSendNotifications();
  }
}
