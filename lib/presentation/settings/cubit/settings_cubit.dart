import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:voca/domain/domain_constants.dart';
import 'package:voca/domain/repositories/user_settings_repository.dart';
import 'package:voca/presentation/base/theming/app_themes.dart';
import 'package:voca/presentation/base/theming/theme_mapper.dart';
import 'package:voca/presentation/notifications/notifications_manager.dart';
import 'package:voca/presentation/settings/cubit/repetition_count_setting_subject.dart';
import 'package:voca/presentation/settings/cubit/settings_events.dart';
import 'package:voca/presentation/settings/cubit/settings_state.dart';

@injectable
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(
    this._notificationsManager,
    this._userSettingsRepository,
    this._countSettingSubject,
  ) : super(const SettingsState());

  final NotificationsManager _notificationsManager;
  final UserSettingsRepository _userSettingsRepository;
  final RepetitionCountSettingSubject _countSettingSubject;

  Stream<SettingsExceptionEvent> get exceptionEvents =>
      _exceptionEventsController.stream;
  final _exceptionEventsController =
      StreamController<SettingsExceptionEvent>.broadcast();

  @override
  Future<void> close() async {
    _exceptionEventsController.close();
    return await super.close();
  }

  Future<void> onInitialize() async {
    assert(_notificationsManager.initSuccess);

    final notifScheduledAt =
        await _notificationsManager.practiceReminderController.scheduledAt();

    final crashReportsEnabled =
        await _userSettingsRepository.isCrashlyticsCollectionAccepted();

    final maxRepetitionCount =
        await _userSettingsRepository.getRepetitionCount();

    emit(state.copyWith(
      practiceRemindersEnabled: _notificationsManager.practiceReminderEnabled,
      reminderShowAt: notifScheduledAt,
      maxRepetitionCount: maxRepetitionCount,
      crashlyticsEnabled: crashReportsEnabled,
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

  Future<void> onSetCrashReports(bool enabled) async {
    emit(state.copyWith(
      crashlyticsEnabled: enabled,
    ));

    await _userSettingsRepository.setCrashlyticsCollectionAccepted(enabled);
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(enabled);
  }

  Future<void> onSetMaxRepetitionCount(int n) async {
    if (!DomainConstants.cardRepetitionSettingWithinRange(n)) {
      return;
    }

    emit(state.copyWith(maxRepetitionCount: n));

    await _userSettingsRepository.setRepetitionCount(n);

    _countSettingSubject.add(n);
  }

  Future<void> onSetTheme(AppTheme theme) async {
    _userSettingsRepository.setTheme(ThemeMapper.toData(theme));
  }
}
