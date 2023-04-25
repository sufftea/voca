// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class SettingsState {
  const SettingsState({
    this.practiceRemindersEnabled,
    this.reminderShowAt = const TimeOfDay(hour: 9, minute: 0),
    this.crashlyticsEnabled,
  });

  final bool? practiceRemindersEnabled;
  final TimeOfDay reminderShowAt;
  final bool? crashlyticsEnabled;

  SettingsState copyWith({
    bool? practiceRemindersEnabled,
    TimeOfDay? reminderShowAt,
    bool? crashlyticsEnabled,
  }) {
    return SettingsState(
      practiceRemindersEnabled: practiceRemindersEnabled ?? this.practiceRemindersEnabled,
      reminderShowAt: reminderShowAt ?? this.reminderShowAt,
      crashlyticsEnabled: crashlyticsEnabled ?? this.crashlyticsEnabled,
    );
  }
}
