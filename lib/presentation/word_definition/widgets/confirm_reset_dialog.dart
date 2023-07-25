import 'package:flutter/material.dart';
import 'package:voca/presentation/base/theming/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';

class ConfirmResetDialog extends StatelessWidget {
  const ConfirmResetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return AlertDialog(
      title: Text(t.wordDefinition.resetDialog.title),
      content: Text(t.wordDefinition.resetDialog.body),
      actions: buildActions(context),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  List<Widget> buildActions(BuildContext context) {
    final theme = Theme.of(context);

    return [
      TextButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop(false);
        },
        style: ButtonStyle(
          textStyle: const MaterialStatePropertyAll(
            TextStyle(
              fontSize: 17,
              fontWeight: FontWeights.medium,
            ),
          ),
          foregroundColor: MaterialStatePropertyAll(theme.colorScheme.primary),
        ),
        child: Text(t.wordDefinition.resetDialog.cancel),
      ),
      FilledButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop(true);
        },
        style: const ButtonStyle(
          textStyle: MaterialStatePropertyAll(
            TextStyle(
              fontSize: 17,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(t.wordDefinition.resetDialog.yes),
        ),
      ),
    ];
  }
}
