import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/widgets/app_bar_card.dart';
import 'package:voca/presentation/word_search/search_bar.dart';

class WordSearchScreen extends StatelessWidget {
  const WordSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColors.white,
      body: Column(
        children: const [
          AppBarCard(
            child: SearchBar(),
          ),
        ],
      ),
    );
  }
}
