import 'package:flutter/material.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_consumer.dart';
import 'package:voca/presentation/base/widgets/base_card.dart';
import 'package:voca/presentation/settings/cubit/settings_cubit.dart';
import 'package:voca/presentation/settings/cubit/settings_state.dart';
import 'package:voca/presentation/settings/widgets/crash_reports_checkbox.dart';
import 'package:voca/presentation/settings/widgets/notifications_checkbox.dart';
import 'package:voca/presentation/settings/widgets/card_repetition_count_slider.dart';

class MiscBanner extends StatefulWidget {
  const MiscBanner({super.key});

  @override
  State<MiscBanner> createState() => _MiscBannerState();
}

class _MiscBannerState extends State<MiscBanner>
    with StatefulCubitConsumer<SettingsCubit, SettingsState, MiscBanner> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BaseCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const NotificationCheckbox(),
          const SizedBox(height: 10),
          const CrashReportsCheckbox(),
          Divider(
            height: 20,
            color: theme.colorScheme.onSecondaryContainer,
            thickness: 0.5,
          ),
          const CardRepetitionCountSlider(),
        ],
      ),
    );
  }
}
