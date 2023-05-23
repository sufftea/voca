import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:receive_intent/receive_intent.dart';
import 'package:voca/injectable/injectable_init.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/global_cubit_provider.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/routing/routers/main/add_word_router.dart';
import 'package:voca/presentation/base/routing/routers/main/main_router.dart';
import 'package:voca/presentation/error/error_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();

  await configureDependencies();

  final router = MainRouter();

  runApp(TranslationProvider(
    child: GlobalCubitProvider(
      child: MaterialApp.router(
        theme: baseTheme,
        routerConfig: router.config(),
      ),
    ),
  ));
}

@pragma('vm:entry-point')
void mainAddWord() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();

  await configureDependencies();

  String? search;
  if (Platform.isAndroid) {
    final intent = (await ReceiveIntent.getInitialIntent())!;
    if (intent.action == 'android.intent.action.PROCESS_TEXT') {
      search = intent.extra?['android.intent.extra.PROCESS_TEXT'] as String;
    }
  }

  final router = AddWordRouter();

  runApp(TranslationProvider(
    child: search != null
        ? MaterialApp.router(
            theme: baseTheme,
            // routerDelegate: delegate,
            routerConfig: router.config(
              deepLinkBuilder: (deepLink) {
                return DeepLink([
                  WordSearchRoute(initialSearch: search),
                ]);
              },
            ),
          )
        : MaterialApp(
            theme: baseTheme,
            home: const ErrorScreen(),
          ),
  ));
}
