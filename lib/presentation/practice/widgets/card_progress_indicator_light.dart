import 'package:flutter/material.dart';

class CardProgressIndicatorLight extends StatelessWidget {
  const CardProgressIndicatorLight({
    required this.currRepetitions,
    required this.maxRepetitionCount,
    super.key,
  });

  final int currRepetitions;
  final int maxRepetitionCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: 3,
      runSpacing: 5,
      children: [
        for (var i = 0; i < maxRepetitionCount; ++i)
          Container(
            width: 20,
            height: 10,
            decoration: BoxDecoration(
              color: i < currRepetitions
                  ? theme.colorScheme.onPrimary
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
              border: Border.all(
                color: theme.colorScheme.onPrimary,
                width: 1,
              ),
            ),
          ),
      ],
    );
  }
}
