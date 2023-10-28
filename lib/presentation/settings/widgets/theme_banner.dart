import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voca/domain/entities/app_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/theming/theming.dart';
import 'package:voca/presentation/base/theming/theme_notifier.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_consumer.dart';
import 'package:voca/presentation/base/utils/extensions/list_x.dart';
import 'package:voca/presentation/base/widgets/base_card.dart';
import 'package:voca/presentation/settings/cubit/settings_cubit.dart';
import 'package:voca/presentation/settings/cubit/settings_state.dart';
import 'package:voca/presentation/settings/widgets/super_switch.dart';

class ThemeBanner extends StatelessWidget
    with CubitConsumer<SettingsCubit, SettingsState> {
  const ThemeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();

    return BaseCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildHeaderAndSwitch(themeNotifier, context),
          const SizedBox(height: 12),
          buildColorSelection(themeNotifier, context),
        ],
      ),
    );
  }

  Row buildHeaderAndSwitch(ThemeNotifier themeNotifier, BuildContext context) {
    return Row(
      children: [
        Text(
          t.settings.theme.header,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeights.bold,
          ),
        ),
        const Spacer(),
        SuperSwitch(
          onTap: () {
            final updatedTheme = themeNotifier.appTheme.copyWith(
              isDark: !themeNotifier.appTheme.isDark,
            );

            themeNotifier.appTheme = updatedTheme;
          },
          value: themeNotifier.appTheme.isDark,
        ),
      ],
    );
  }

  Row buildColorSelection(ThemeNotifier themeNotifier, BuildContext context) {
    final colors = <(ThemeColors, ThemeData)>[];

    for (final ThemeColors color in ThemeColors.values) {
      colors.add((
        color,
        composeTheme(AppTheme(
          themeColor: color,
          isDark: themeNotifier.appTheme.isDark,
        )),
      ));
    }

    return Row(
      children: [
        for (final (i, (themeColor, themeData)) in colors.enumerate()) ...[
          if (i != 0) const SizedBox(width: 8),
          Expanded(
            child: Theme(
              data: themeData,
              child: FilledButton(
                onPressed: () async {
                  final updatedTheme = themeNotifier.appTheme.copyWith(
                    themeColor: themeColor,
                  );

                  themeNotifier.appTheme = updatedTheme;
                },
                style: ButtonStyle(
                  padding: const MaterialStatePropertyAll(EdgeInsets.zero),
                  side: MaterialStatePropertyAll(BorderSide(
                    color: themeData.colorScheme.onPrimaryContainer,
                    width: themeNotifier.appTheme.themeColor == themeColor ? 2 : 0,
                  )),
                ),
                child: SizedBox(
                  height: 32,
                  child: Center(
                    child: themeNotifier.appTheme.themeColor == themeColor
                        ? const Icon(Icons.check)
                        : null,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
