import 'package:flutter/material.dart';
import 'package:voca/presentation/base/theming/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_consumer.dart';
import 'package:voca/presentation/settings/cubit/settings_cubit.dart';
import 'package:voca/presentation/settings/cubit/settings_state.dart';

class CrashReportsCheckbox extends StatelessWidget
    with CubitConsumer<SettingsCubit, SettingsState> {
  const CrashReportsCheckbox({super.key});

  void onCheckBoxPressed(BuildContext context, bool? enabled) {
    if (enabled == null) {
      return;
    }
    cubit(context).onSetCrashReports(enabled);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        buildCheckBox(),
        const SizedBox(width: 10),
        buildText(context),
      ],
    );
  }

  Widget buildCheckBox() {
    return builder(
      buildWhen: (prev, curr) =>
          prev.crashlyticsEnabled != curr.crashlyticsEnabled,
      builder: (context, state) {
        return Container(
          height: 20,
          width: 20,
          alignment: Alignment.center,
          child: Checkbox(
            value: state.crashlyticsEnabled,
            tristate: state.crashlyticsEnabled == null,
            onChanged: switch (state.crashlyticsEnabled == null) {
              false => (enabled) => onCheckBoxPressed(context, enabled),
              true => null,
            },
          ),
        );
      },
    );
  }

  Expanded buildText(BuildContext context) {
    final t = Translations.of(context);

    return Expanded(
      child: Text(
        t.settings.misc.crashReports,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeights.regular,
        ),
      ),
    );
  }
}
