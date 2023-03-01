import 'package:flutter/material.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/widgets/app_bar_card.dart';
import 'package:voca/presentation/settings/widgets/word_list_buttons_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: WordListsButtonsWidget(),
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return const AppBarCard(
      child: Text(
        'Settings',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeights.bold,
        ),
      ),
    );
  }
}
