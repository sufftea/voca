import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:voca/presentation/notifications/notifications_manager.dart';
import 'package:voca/presentation/settings/cubit/settings_events.dart';
import 'package:voca/presentation/settings/cubit/settings_state.dart';

@injectable
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(
    this._notificationsManager,
  ) : super(const SettingsState());

  final NotificationsManager _notificationsManager;

  Stream<SettingsExceptionEvent> get exceptionEvents =>
      _exceptionEventsController.stream;
  final _exceptionEventsController =
      StreamController<SettingsExceptionEvent>.broadcast();

  Future<void> onScreenOpened() async {
    assert(_notificationsManager.initSuccess);

    final notifScheduledAt =
        await _notificationsManager.practiceReminderController.scheduledAt();

    emit(state.copyWith(
      practiceRemindersEnabled: _notificationsManager.practiceReminderEnabled,
      reminderShowAt: notifScheduledAt,
    ));
  }

  Future<void> onEnableNotifications({TimeOfDay? showAt}) async {
    assert(_notificationsManager.initSuccess);

    emit(state.copyWith(practiceRemindersEnabled: true));

    showAt ??= state.reminderShowAt;

    try {
      if (!await _notificationsManager.requestPermissions()) {
        return;
      }

      await _notificationsManager.practiceReminderController.createNotification(
        showAt: showAt,
      );

      await _notificationsManager.updateEnabledNotifications();
    } on Exception catch (e) {
      debugPrint(e.toString());

      _exceptionEventsController.add(
        const SettingsExceptionEvent('Something went wrong'),
      );

      return;
    }

    emit(state.copyWith(
      practiceRemindersEnabled: _notificationsManager.practiceReminderEnabled,
      reminderShowAt:
          _notificationsManager.practiceReminderEnabled ? showAt : null,
    ));
  }

  Future<void> onDisableNotifications() async {
    assert(_notificationsManager.initSuccess);

    emit(state.copyWith(practiceRemindersEnabled: false));

    try {
      await _notificationsManager.practiceReminderController
          .cancelNotification();
      await _notificationsManager.updateEnabledNotifications();
    } on Exception catch (e) {
      debugPrint(e.toString());

      _exceptionEventsController.add(
        const SettingsExceptionEvent('Something went wrong'),
      );

      return;
    }

    emit(state.copyWith(
      practiceRemindersEnabled: _notificationsManager.practiceReminderEnabled,
    ));
  }

  @override
  Future<void> close() async {
    await super.close();

    _exceptionEventsController.close();
  }
}
