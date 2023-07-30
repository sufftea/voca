import 'package:flutter/material.dart';
import 'package:voca/presentation/base/theming/app_themes.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_consumer.dart';
import 'package:voca/presentation/settings/cubit/settings_cubit.dart';
import 'package:voca/presentation/settings/cubit/settings_state.dart';

class NotificationCheckbox extends StatefulWidget {
  const NotificationCheckbox({super.key});

  @override
  State<NotificationCheckbox> createState() => _NotificationCheckboxState();
}

class _NotificationCheckboxState extends State<NotificationCheckbox>
    with
        StatefulCubitConsumer<SettingsCubit, SettingsState,
            NotificationCheckbox> {
  Future<TimeOfDay?> _showTimePicker(
    BuildContext context, {
    required TimeOfDay currSelected,
  }) async {
    return showTimePicker(
      context: context,
      initialTime: currSelected,
      initialEntryMode: TimePickerEntryMode.dial,
      useRootNavigator: true,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: child!,
        );
      },
    );
  }

  Future<void> onCheckBoxPressed(bool? enabled) async {
    if (enabled == null) {
      return;
    } else if (enabled) {
      await cubit.onEnableNotifications();
    } else {
      await cubit.onDisableNotifications();
    }
  }

  Future<void> onTimeButtonPressed(SettingsState state) async {
    final time = await _showTimePicker(
      context,
      currSelected: state.reminderShowAt,
    );

    if (time == null) {
      return;
    }

    cubit.onEnableNotifications(showAt: time);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        buildCheckBox(),
        const SizedBox(width: 12),
        buildText(),
        const SizedBox(width: 12),
        buildTimeButton(context),
      ],
    );
  }

  Widget buildCheckBox() {
    return builder(
      buildWhen: (prev, curr) =>
          prev.practiceRemindersEnabled != curr.practiceRemindersEnabled,
      builder: (context, state) {
        return Container(
          height: 16,
          width: 16,
          alignment: Alignment.center,
          child: Checkbox(
            value: state.practiceRemindersEnabled,
            tristate: state.practiceRemindersEnabled == null,
            onChanged: state.practiceRemindersEnabled == null
                ? null
                : onCheckBoxPressed,
          ),
        );
      },
    );
  }

  Expanded buildText() {
    return Expanded(
      child: Text(
        t.settings.misc.dailyReminders,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeights.regular,
        ),
      ),
    );
  }

  Widget buildTimeButton(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    return builder(builder: (context, state) {
      return FilledButton(
        onPressed: state.practiceRemindersEnabled ?? false
            ? () => onTimeButtonPressed(state)
            : null,
        style: ButtonStyle(
          overlayColor: mspResolveWith(
              none: theme.colorScheme.primaryContainer.withOpacity(0.1)),
          backgroundColor: mspResolveWith(
            none: theme.colorScheme.onSecondary,
          ),
          foregroundColor: mspResolveWith(
            disabled: theme.colorScheme.secondaryContainer,
            none: theme.colorScheme.secondary,
          ),
          textStyle: mspResolveWith(
            none: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeights.medium,
            ),
          ),
        ),
        child: Text(
          t.settings.misc.atTime(
            time: state.reminderShowAt.format(context),
          ),
        ),
      );
    });
  }
}
