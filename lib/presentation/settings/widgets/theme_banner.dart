import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/theming/app_themes.dart';
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
    final t = Translations.of(context);

    return BaseCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildHeaderAndSwitch(themeNotifier, context),
          const SizedBox(height: 16),
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
              dark: !themeNotifier.appTheme.dark,
            );

            themeNotifier.appTheme = updatedTheme;
            cubit(context).onSetTheme(updatedTheme);
          },
          value: themeNotifier.appTheme.dark,
        ),
      ],
    );
  }

  Row buildColorSelection(ThemeNotifier themeNotifier, BuildContext context) {
    final cols = <(int, AppThemeName, ThemeData)>[];

    for (final (int i, AppThemeName themeName)
        in AppThemeName.values.enumerate()) {
      cols.add((
        i,
        themeName,
        composeTheme(themeNotifier.appTheme.copyWith(name: themeName)),
      ));
    }

    return Row(
      children: [
        for (final (i, themeName, themeData) in cols) ...[
          if (i != 0) const SizedBox(width: 8),
          Expanded(
            child: Theme(
              data: themeData,
              child: FilledButton(
                onPressed: () async {
                  final updatedTheme = themeNotifier.appTheme.copyWith(
                    name: themeName,
                  );

                  themeNotifier.appTheme = updatedTheme;
                  await cubit(context).onSetTheme(updatedTheme);
                },
                style: ButtonStyle(
                  padding: const MaterialStatePropertyAll(EdgeInsets.zero),
                  side: MaterialStatePropertyAll(BorderSide(
                    color: themeData.colorScheme.onPrimaryContainer,
                    width: themeNotifier.appTheme.name == themeName ? 2 : 0,
                  )),
                ),
                child: SizedBox(
                  height: 32,
                  child: Center(
                    child: themeNotifier.appTheme.name == themeName
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
