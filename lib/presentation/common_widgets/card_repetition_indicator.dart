import 'package:flutter/material.dart';

class CardRepetitionIndicator extends StatelessWidget {
  const CardRepetitionIndicator({
    required this.repetitionCount,
    required this.maxRepetitionCount,
    super.key,
  });

  final int repetitionCount;
  final int maxRepetitionCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      runSpacing: 3,
      spacing: 5,
      children: [
        for (var i = 0; i < maxRepetitionCount; ++i)
          Container(
            width: 20,
            height: 10,
            decoration: i < repetitionCount
                ? BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(3),
                  )
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.transparent,
                    border: Border.all(
                      color: theme.colorScheme.primary,
                      width: 1,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                  ),
          ),
      ],
    );
  }
}
