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
          Text(
            t.settings.theme.header,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeights.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (final (int i, entry) in themes.entries.enumerate()) ...[
                if (i != 0) const SizedBox(width: 8),
                Expanded(
                  child: Theme(
                    data: entry.value,
                    child: FilledButton(
                      onPressed: () async {
                        await cubit(context).onSetTheme(entry.key);
                        themeNotifier.appTheme = entry.key;
                      },
                      style: ButtonStyle(
                        padding:
                            const MaterialStatePropertyAll(EdgeInsets.zero),
                        side: MaterialStatePropertyAll(BorderSide(
                          color: entry.value.colorScheme.onPrimaryContainer,
                          width: themeNotifier.appTheme == entry.key ? 2 : 0,
                        )),
                      ),
                      child: SizedBox(
                        height: 32,
                        child: Center(
                          child: themeNotifier.appTheme == entry.key
                              ? const Icon(Icons.check)
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
