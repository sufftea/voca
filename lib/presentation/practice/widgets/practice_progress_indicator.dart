import 'package:flutter/material.dart';
import 'package:voca/presentation/base/base_theme.dart';

class PracticeProgressIndicator extends StatelessWidget {
  const PracticeProgressIndicator({
    required this.currRepetitions,
    required this.totalRepetitions,
    super.key,
  });

  final int currRepetitions;
  final int totalRepetitions;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < totalRepetitions; ++i) ...[
          Container(
            width: 20,
            height: 10,
            decoration: BoxDecoration(
              color: i < currRepetitions
                  ? BaseColors.white
                  : BaseColors.transparent,
              borderRadius: BorderRadius.circular(2),
              border: Border.all(
                color: BaseColors.white,
                width: 1,
              ),
            ),
          ),
          const SizedBox(width: 5),
        ]
      ],
    );
  }
}
