import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/l10n.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_consumer.dart';
import 'package:voca/presentation/base/utils/loading_state/loading_state.dart';
import 'package:voca/presentation/base/widgets/app_bar_card.dart';
import 'package:voca/presentation/base/widgets/placeholder.dart';
import 'package:voca/presentation/entities/word_range.dart';
import 'package:voca/presentation/word_range/cubit/word_range_list_cubit.dart';
import 'package:voca/presentation/word_range/cubit/word_range_list_state.dart';
import 'package:voca/presentation/word_range/widgets/word_ranges_graph.dart';

class WordRangeListScreen extends StatefulWidget {
  const WordRangeListScreen({super.key});

  @override
  State<WordRangeListScreen> createState() => _WordRangeListScreenState();
}

class _WordRangeListScreenState extends State<WordRangeListScreen>
    with
        StatefulCubitConsumer<WordRangeListCubit,
            LoadingState<WordRrangeListState>, WordRangeListScreen> {
  @override
  void initState() {
    super.initState();
    cubit.startLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColors.white,
      body: Column(
        children: [
          buildAppBar(),
          buildBody(),
        ],
      ),
    );
  }

  buildAppBar() {
    return AppBarCard(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildActions(),
        ],
      ),
    );
  }

  Widget buildActions() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            GoRouter.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_outlined),
          iconSize: 28,
          constraints: const BoxConstraints(
            minHeight: 48,
            minWidth: 48,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.question_mark),
          iconSize: 28,
          constraints: const BoxConstraints(
            minHeight: 48,
            minWidth: 48,
          ),
        ),
      ],
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildGraph(),
          const SizedBox(height: 20),
          buildRangeSelection(),
        ],
      ),
    );
  }

  Widget buildGraph() {
    return builder(
      (context, state) {
        return state.readyMap(
          loading: () => const PlaceholderCard(height: 400),
          ready: (data) => WordRangesGraph(ranges: data.ranges),
        );
      },
      buildWhen: (prev, curr) =>
          prev.readyData?.ranges != curr.readyData?.ranges ||
          prev.readyData?.selectedRange != curr.readyData?.selectedRange,
    );
  }

  Widget buildRangeSelection() {
    return builder(
      (context, state) {
        return state.readyMap(
          loading: () => const PlaceholderCard(height: 50),
          ready: (data) => bulidRangeSelectionReady(
            selectedRange: data.selectedRange,
            ranges: data.ranges,
          ),
        );
      },
      buildWhen: (prev, curr) =>
          prev.readyData?.selectedRange != curr.readyData?.selectedRange,
    );
  }

  Widget bulidRangeSelectionReady({
    required WordRange selectedRange,
    required List<WordRange> ranges,
  }) {
    final min = ranges.first.low.toDouble();
    final max = ranges.last.high.toDouble();

    final f = NumberFormat.compact();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Intls.current.selectedRange,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeights.bold,
            ),
          ),
          RangeSlider(
            
            values: RangeValues(
              selectedRange.low.toDouble(),
              selectedRange.high.toDouble(),
            ),
            min: min,
            max: max,
            labels: RangeLabels(
              f.format(selectedRange.low),
              f.format(selectedRange.high),
            ),
            divisions: ranges.length,
            onChanged: (value) {
              cubit.onRangeSelectionChanged(
                  value.start.toInt(), value.end.toInt());
            },
          ),
        ],
      ),
    );
  }
}
