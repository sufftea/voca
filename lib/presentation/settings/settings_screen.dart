import 'package:flutter/material.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/widgets/app_bar_card.dart';
import 'package:voca/presentation/settings/widgets/about_banner.dart';
import 'package:voca/presentation/settings/widgets/word_lists_banner.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildAppBar(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  SizedBox(height: 10),
                  WordListsBanner(),
                  SizedBox(height: 10),
                  AboutBanner(),
                ],
              ),
            ),
          ],
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
