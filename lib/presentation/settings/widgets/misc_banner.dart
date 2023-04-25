import 'package:flutter/material.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_consumer.dart';
import 'package:voca/presentation/base/widgets/base_card.dart';
import 'package:voca/presentation/settings/cubit/settings_cubit.dart';
import 'package:voca/presentation/settings/cubit/settings_state.dart';
import 'package:voca/presentation/settings/widgets/crash_reports_checkbox.dart';
import 'package:voca/presentation/settings/widgets/notifications_checkbox.dart';

class MiscBanner extends StatefulWidget {
  const MiscBanner({super.key});

  @override
  State<MiscBanner> createState() => _MiscBannerState();
}

class _MiscBannerState extends State<MiscBanner>
    with StatefulCubitConsumer<SettingsCubit, SettingsState, MiscBanner> {
  @override
  Widget build(BuildContext context) {
    return const BaseCard(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NotificationCheckbox(),
          SizedBox(height: 10),
          CrashReportsCheckbox(),
        ],
      ),
    );
  }
}
