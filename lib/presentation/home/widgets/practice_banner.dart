import 'package:flutter/material.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/strings.g.dart';
import 'package:voca/presentation/base/widgets/base_card.dart';
import 'package:voca/presentation/base/widgets/placeholder_or.dart';
import 'package:voca/presentation/home/widgets/todays_goal_progress_bar.dart';

class PracticeBanner extends StatelessWidget {
  const PracticeBanner({
    required this.todaysGoal,
    required this.todaysGoalCompleted,
    super.key,
  });

  static const placeholder = PlaceholderOr(
      real: PracticeBanner(todaysGoal: 0, todaysGoalCompleted: 0));

  final int todaysGoal;
  final int todaysGoalCompleted;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return BaseCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            t.home.practiceBanner.header,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeights.bold,
            ),
          ),
          const SizedBox(height: 20),
          TodaysGoalProgBar(
            goal: todaysGoal,
            completed: todaysGoalCompleted,
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {},
            child: Text(t.home.practiceBanner.practice),
          ),
        ],
      ),
    );
  }
}
