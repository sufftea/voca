import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:voca/presentation/base/theming/theming.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_consumer.dart';
import 'package:voca/presentation/settings/cubit/settings_cubit.dart';
import 'package:voca/presentation/settings/cubit/settings_state.dart';
import 'package:voca/presentation/settings/widgets/about_banner.dart';
import 'package:voca/presentation/settings/widgets/misc_banner.dart';
import 'package:voca/presentation/settings/widgets/theme_banner.dart';
import 'package:voca/presentation/settings/widgets/word_lists_banner.dart';

@RoutePage()
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with StatefulCubitConsumer<SettingsCubit, SettingsState, SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: DefaultTextStyle(
        style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      t.settings.header,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeights.bold,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      WordListsBanner(),
                      SizedBox(height: 12),
                      MiscBanner(),
                      SizedBox(height: 12),
                      AboutBanner(),
                      SizedBox(height: 12),
                      ThemeBanner(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
