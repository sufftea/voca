import 'package:flutter/material.dart';
import 'package:voca/injectable/injectable_init.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/l10n.dart';
import 'package:voca/presentation/base/router.dart';

void main() async {
  await Intls.load(const Locale('us'));
  configureDependencies();

  runApp(MaterialApp.router(
    theme: baseTheme,
    routerConfig: router,
  ));
}
