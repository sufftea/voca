import 'package:flutter/material.dart';
import 'package:voca/injectable/injectable_init.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/routing/create_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();

  final router = await createRouter();

  await configureDependencies();

  runApp(TranslationProvider(
    child: MaterialApp.router(
      theme: baseTheme,
      routerConfig: router,
    ),
  ));
}
