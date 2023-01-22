import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/l10n.dart';
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
    return BaseCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            Intls.current.practiceBannerTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeights.bold,
              color: BaseColors.mineShaft,
            ),
          ),
          const SizedBox(height: 20),
          TodaysGoalProgBar(
            goal: todaysGoal,
            completed: todaysGoalCompleted,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: const ButtonStyle(
              padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
            ),
            child: Text(Intls.current.practice),
          ),
        ],
      ),
    );
  }
}
