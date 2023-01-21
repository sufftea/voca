import 'package:flutter/material.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/widgets/app_bar_card.dart';
import 'package:voca/presentation/word_search/search_bar.dart';
import 'package:voca/presentation/word_search/search_bar_hero_data.dart';

final k = GlobalKey();

class WordSearchScreen extends StatefulWidget {
  const WordSearchScreen({super.key});

  @override
  State<WordSearchScreen> createState() => _WordSearchScreenState();
}

class _WordSearchScreenState extends State<WordSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColors.white,
      body: Column(
        children: [
          Hero(
            tag: SearchBarHeroData.tag,
            child: Material(
              type: MaterialType.transparency,
              child: AppBarCard(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SearchBar(
                    key: k,
                    autofocus: true,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
