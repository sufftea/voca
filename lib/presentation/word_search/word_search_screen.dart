import 'package:flutter/material.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_consumer.dart';
import 'package:voca/presentation/word_search/cubit/search_cubit.dart';
import 'package:voca/presentation/word_search/cubit/search_state.dart';

final k = GlobalKey();

class WordSearchScreen extends StatefulWidget {
  const WordSearchScreen({super.key});

  @override
  State<WordSearchScreen> createState() => _WordSearchScreenState();
}

class _WordSearchScreenState extends State<WordSearchScreen>
    with StatefulCubitConsumer<SearchCubit, SearchState, WordSearchScreen> {
  @override
  void initState() {
    super.initState();

    test();
  }

  void test() async {
    debugPrint('starting search');
    
    await cubit.onSearchTextChanged('worl');

    final results = cubit.state.results;

    for (final word in results) {
      debugPrint(word.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
