import 'package:flutter/material.dart';
import 'package:voca/presentation/base/theming/app_themes.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';

class PracticeResultsCardWidget extends StatelessWidget {
  const PracticeResultsCardWidget({
    required this.remembered,
    required this.forgotten,
    super.key,
  });

  final int remembered;
  final int forgotten;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    return DefaultTextStyle(
      style: TextStyle(color: theme.colorScheme.onSurface),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.8),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: theme.colorScheme.secondary,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  t.practice.wordsRemembered,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeights.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  remembered.toString(),
                  style: TextStyle(
                    fontSize: 15,
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeights.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  t.practice.wordsForgotten,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeights.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  forgotten.toString(),
                  style: TextStyle(
                    fontSize: 15,
                    color: theme.colorScheme.error,
                    fontWeight: FontWeights.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
