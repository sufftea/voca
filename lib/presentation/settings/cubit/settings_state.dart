// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class SettingsState {
  const SettingsState({
    this.practiceRemindersEnabled,
    this.reminderShowAt = const TimeOfDay(hour: 9, minute: 0),
  });

  final bool? practiceRemindersEnabled;
  final TimeOfDay reminderShowAt;

  SettingsState copyWith({
    bool? practiceRemindersEnabled,
    TimeOfDay? reminderShowAt,
  }) {
    return SettingsState(
      practiceRemindersEnabled: practiceRemindersEnabled ?? this.practiceRemindersEnabled,
      reminderShowAt: reminderShowAt ?? this.reminderShowAt,
    );
  }
}
