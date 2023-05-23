import 'package:flutter/material.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Scaffold(
      body: Center(
        child: Text(
          t.error.somethingWentWrong,
          style: const TextStyle(
            fontSize: 19,
          ),
        ),
      ),
    );
  }
}
