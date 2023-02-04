import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/strings.g.dart';
import 'package:voca/presentation/entities/word_range.dart';

const _barWidth = 25.0;

class WordRangesGraph extends StatelessWidget {
  const WordRangesGraph({
    required this.ranges,
    super.key,
  });

  final List<WordRange> ranges;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildLegend(context),
        buildGraph(),
      ],
    );
  }

  Widget buildLegend(BuildContext context) {
    final t = Translations.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Row(
        children: [
          buildLabel(t.rangeSelection.learning, BaseColors.curiousBlue),
          const SizedBox(width: 20),
          buildLabel(t.rangeSelection.known, BaseColors.neptune),
        ],
      ),
    );
  }

  Widget buildLabel(
    String text,
    Color color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: color,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget buildGraph() {
    return SizedBox(
      height: 400,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 10),
            for (var i = 0; i < ranges.length; ++i) buildRange(ranges[i], i),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  Widget buildRange(WordRange range, int index) {
    return Container(
      width: _barWidth,
      padding: const EdgeInsets.only(right: 2),
      child: Column(
        children: [
          buildLearningNumber(range),
          buildLearningBar(range),
          buildRangeNumber(range, index),
          buildKnowBar(range),
          buildKnowAmount(range),
        ],
      ),
    );
  }

  Widget buildKnowAmount(WordRange range) {
    return SizedBox(
      height: 50,
      child: RotatedBox(
        quarterTurns: 1,
        child: Text(
          range.knowNumber.toString(),
          style: const TextStyle(
            fontWeight: FontWeights.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget buildKnowBar(WordRange range) {
    return Expanded(
      child: Align(
        alignment: Alignment.topCenter,
        child: LayoutBuilder(builder: (context, constraints) {
          final h = constraints.maxHeight;
          final percent = range.knowNumber / range.amount;

          return Container(
            height: h * percent,
            decoration: BoxDecoration(
              color: BaseColors.neptune,
              borderRadius: BorderRadius.circular(3),
            ),
          );
        }),
      ),
    );
  }

  Widget buildRangeNumber(WordRange range, int index) {
    if (index % 2 != 0) {
      return Container(
        height: 25,
        alignment: Alignment.center,
        child: Container(
          width: 3,
          height: 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: BaseColors.mineShaft,
          ),
        ),
      );
    }
    return Container(
      height: 25,
      alignment: Alignment.center,
      child: Text(
        NumberFormat.compact().format(range.high),
        style: const TextStyle(fontSize: 12, fontWeight: FontWeights.bold),
      ),
    );
  }

  Widget buildLearningBar(WordRange range) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: LayoutBuilder(builder: (context, constraints) {
          final h = constraints.maxHeight;
          final percent = range.learningNumber / range.amount;

          return Container(
            height: h * percent,
            decoration: BoxDecoration(
              color: BaseColors.curiousBlue,
              borderRadius: BorderRadius.circular(3),
            ),
          );
        }),
      ),
    );
  }

  Widget buildLearningNumber(WordRange range) {
    return SizedBox(
      height: 50,
      child: RotatedBox(
        quarterTurns: 1,
        child: Text(
          range.learningNumber.toString(),
          textAlign: TextAlign.end,
          style: const TextStyle(
            fontWeight: FontWeights.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
