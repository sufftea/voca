import 'package:flutter/material.dart';
import 'package:voca/presentation/base/base_theme.dart';
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

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BaseColors.white80,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: BaseColors.curiousBlue,
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
              const SizedBox(width: 3),
              Text(
                remembered.toString(),
                style: const TextStyle(
                  fontSize: 15,
                  color: BaseColors.curiousBlue,
                  fontWeight: FontWeights.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
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
              const SizedBox(width: 3),
              Text(
                forgotten.toString(),
                style: const TextStyle(
                  fontSize: 15,
                  color: BaseColors.bittersweet,
                  fontWeight: FontWeights.bold,
                ),
              ),
            ],
          ),
          
        ],
      ),
    );
  }
}
