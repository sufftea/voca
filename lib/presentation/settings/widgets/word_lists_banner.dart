import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:voca/presentation/base/theming/app_themes.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/routing/routers/main/main_router.dart';
import 'package:voca/presentation/base/widgets/base_card.dart';

class WordListsBanner extends StatelessWidget {
  const WordListsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme= Theme.of(context);

    return BaseCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            t.settings.words,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeights.bold,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          buildLearningButton(context),
        ],
      ),
    );
  }

  Widget buildLearningButton(BuildContext context) {
    final t = Translations.of(context);

    return OutlinedButton(
      onPressed: () {
        final router = AutoRouter.of(context);
        router.push(const LearningListRoute());
      },
      style: const ButtonStyle(
        alignment: Alignment.center,
      ),
      child: Text(
        t.common.learning,
        style: const TextStyle(
          fontSize: 15,
        ),
      ),
    );
  }
}
