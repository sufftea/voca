import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';

class PracticeReminderNotificationController {
  static const channelKey = 'daily_reminders';

  static final channel = NotificationChannel(
    channelKey: channelKey,
    channelName: t.notifications.dailyReminder.channelName,
    channelDescription: t.notifications.dailyReminder.channelDescription,
    defaultColor: BaseColors.curiousBlue,
    ledColor: null,
  );

  const PracticeReminderNotificationController();

  Future<void> createNotification({
    required TimeOfDay showAt,
  }) async {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0,
        channelKey: channelKey,
        title: t.notifications.dailyReminder.title,
        body: t.notifications.dailyReminder.body,
        actionType: ActionType.Default,
        autoDismissible: true,
        
      ),
      schedule: NotificationCalendar(
        hour: showAt.hour,
        minute: showAt.minute,
        repeats: true,
      ),
    );
  }

  Future<TimeOfDay?> scheduledAt() async {
    final scheduledNotifs =
        await AwesomeNotifications().listScheduledNotifications();

    final filtered = scheduledNotifs.where(
      (element) => element.content?.channelKey == channelKey,
    );

    if (filtered.isEmpty) {
      return null;
    }

    final schedule = filtered.first.schedule as NotificationCalendar;

    if (schedule.hour == null || schedule.minute == null) {
      return null;
    }

    return TimeOfDay(hour: schedule.hour!, minute: schedule.minute!);
  }

  Future<void> cancelNotification() async {
    await AwesomeNotifications().cancelNotificationsByChannelKey(channelKey);
  }
}
