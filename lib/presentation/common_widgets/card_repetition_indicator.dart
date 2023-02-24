import 'package:flutter/material.dart';
import 'package:voca/domain/domain_constants.dart';
import 'package:voca/presentation/base/base_theme.dart';

class CardRepetitionIndicator extends StatelessWidget {
  const CardRepetitionIndicator({
    required this.repetitionCount,
    super.key,
  });

  final int repetitionCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < DomainConstants.maxRepetitionCount; ++i) ...[
          if (i != 0) const SizedBox(width: 5),
          Container(
            width: 20,
            height: 10,
            decoration: i < repetitionCount
                ? BoxDecoration(
                    color: BaseColors.curiousBlue,
                    borderRadius: BorderRadius.circular(3))
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: BaseColors.white,
                    border: Border.all(
                      color: BaseColors.curiousBlue,
                      width: 0.5,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                  ),
          ),
        ]
      ],
    );
  }
}
