import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/routing/router.dart';
import 'package:voca/presentation/base/widgets/app_bar_card.dart';
import 'package:voca/presentation/settings/widgets/learning_list_buttons_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: LearningListButtonsWidget(),
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
