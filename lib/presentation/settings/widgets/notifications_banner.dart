import 'package:flutter/material.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_consumer.dart';
import 'package:voca/presentation/base/widgets/base_card.dart';
import 'package:voca/presentation/settings/cubit/settings_cubit.dart';
import 'package:voca/presentation/settings/cubit/settings_state.dart';

class NotificationsBanner extends StatefulWidget {
  const NotificationsBanner({super.key});

  @override
  State<NotificationsBanner> createState() => _NotificationsBannerState();
}

class _NotificationsBannerState extends State<NotificationsBanner>
    with
        StatefulCubitConsumer<SettingsCubit, SettingsState,
            NotificationsBanner> {
  Future<TimeOfDay?> _showTimePicker(
    BuildContext context, {
    required TimeOfDay currSelected,
  }) async {
    return showTimePicker(
      context: context,
      initialTime: currSelected,
      initialEntryMode: TimePickerEntryMode.dial,
    );
  }

  Future<void> _onCheckBoxPressed(bool? enabled) async {
    if (enabled == null) {
      return;
    } else if (enabled) {
      await cubit.onEnableNotifications();
    } else {
      await cubit.onDisableNotifications();
    }
  }

  Future<void> _onTimeButtonPressed(SettingsState state) async {
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
    return BaseCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildHeader(context),
          const SizedBox(height: 5),
          Row(
            children: [
              buildCheckBox(),
              const SizedBox(width: 10),
              buildText(),
              buildTimeButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCheckBox() {
    return builder(
      buildWhen: (prev, curr) =>
          prev.practiceRemindersEnabled != curr.practiceRemindersEnabled,
      builder: (context, state) {
        return Container(
          height: 20,
          width: 20,
          alignment: Alignment.center,
          child: Checkbox(
            value: state.practiceRemindersEnabled,
            tristate: state.practiceRemindersEnabled == null,
            onChanged: state.practiceRemindersEnabled == null
                ? null
                : _onCheckBoxPressed,
          ),
        );
      },
    );
  }

  Expanded buildText() {
    return Expanded(
      child: Text(
        t.settings.notifications.dailyReminders,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeights.regular,
        ),
      ),
    );
  }

  Widget buildTimeButton(BuildContext context) {
    final t = Translations.of(context);

    return Row(
      children: [
        const SizedBox(width: 30),
        builder(builder: (context, state) {
          return FilledButton(
            onPressed: state.practiceRemindersEnabled ?? false
                ? () => _onTimeButtonPressed(state)
                : null,
            style: ButtonStyle(
              overlayColor: mspResolveWith(none: BaseColors.botticelly),
              backgroundColor: mspResolveWith(
                none: BaseColors.white,
              ),
              foregroundColor: mspResolveWith(
                disabled: BaseColors.curiousBlue30,
                none: BaseColors.curiousBlue,
              ),
              textStyle: mspResolveWith(
                none: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeights.medium,
                ),
              ),
            ),
            child: Text(t.settings.notifications.atTime(
              time: state.reminderShowAt.format(context),
            )),
          );
        }),
      ],
    );
  }

  Widget buildHeader(BuildContext context) {
    final t = Translations.of(context);

    return Text(
      t.settings.notifications.header,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeights.bold,
      ),
    );
  }
}
