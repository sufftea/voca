import 'package:flutter/material.dart';
import 'package:voca/injectable/injectable_init.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/strings.g.dart';
import 'package:voca/presentation/base/routing/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();

  configureDependencies();

  runApp(TranslationProvider(
    child: MaterialApp.router(
      theme: baseTheme,
      routerConfig: router,
    ),
  ));
}
