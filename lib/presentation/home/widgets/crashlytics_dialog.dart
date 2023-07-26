import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';
import 'package:voca/presentation/base/theming/app_themes.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';

class CrashlyticsDialog extends StatelessWidget {
  const CrashlyticsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              t.home.crashlyticsPermission.header,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeights.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 10),
            StyledText(
              text: t.home.crashlyticsPermission.body,
              tags: {
                'accent': StyledTextTag(
                    style: const TextStyle(
                  fontWeight: FontWeights.bold,
                  // color: BaseColors.
                )),
              },
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeights.light,
              ),
            ),
            const SizedBox(height: 10),
            buildButtons(context, theme),
          ],
        ),
      ),
    );
  }

  Row buildButtons(BuildContext context, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          style: ButtonStyle(
              foregroundColor:
                  MaterialStatePropertyAll(theme.colorScheme.primary),
              textStyle: const MaterialStatePropertyAll(TextStyle(
                fontSize: 15,
                fontWeight: FontWeights.bold,
              ))),
          child: Text(t.home.crashlyticsPermission.deny),
        ),
        const SizedBox(width: 10),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(
            t.home.crashlyticsPermission.allow,
          ),
        ),
      ],
    );
  }
}
