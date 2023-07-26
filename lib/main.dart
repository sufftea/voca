import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receive_intent/receive_intent.dart';
import 'package:voca/domain/repositories/user_settings_repository.dart';
import 'package:voca/firebase_options.dart';
import 'package:voca/injectable/injectable_init.dart';
import 'package:voca/presentation/base/app_dependencies.dart';
import 'package:voca/presentation/base/theming/theme_mapper.dart';
import 'package:voca/presentation/base/theming/theme_notifier.dart';
import 'package:voca/presentation/base/l10n/gen/strings.g.dart';
import 'package:voca/presentation/base/routing/routers/main/add_word_router.dart';
import 'package:voca/presentation/base/routing/routers/main/main_router.dart';
import 'package:voca/presentation/error/error_screen.dart';

Future<void> initStuff() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();

  await configureDependencies();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (exception, stackTrace) {
    FirebaseCrashlytics.instance.recordError(
      exception,
      stackTrace,
      fatal: true,
    );
    return true;
  };
}

void main() async {
  await initStuff();

  final router = MainRouter();

  final theme = ThemeMapper.fromData(
    await getIt.get<UserSettingsRepository>().getTheme(),
  );

  runApp(AppDependencies(
    theme: theme,
    builder: (context) {
      return MaterialApp.router(
        theme: context.watch<ThemeNotifier>().themeData,
        routerConfig: router.config(),
      );
    },
  ));
}

@pragma('vm:entry-point')
void mainAddWord() async {
  await initStuff();

  String? search;
  if (Platform.isAndroid) {
    final intent = (await ReceiveIntent.getInitialIntent())!;
    if (intent.action == 'android.intent.action.PROCESS_TEXT') {
      search = intent.extra?['android.intent.extra.PROCESS_TEXT'] as String;
    }
  }

  final router = AddWordRouter();

  final theme = ThemeMapper.fromData(
    await getIt.get<UserSettingsRepository>().getTheme(),
  );

  runApp(AppDependencies(
    theme: theme,
    builder: (context) {
      final themeData = context.watch<ThemeNotifier>().themeData;

      if (search == null) {
        return MaterialApp(
          theme: themeData,
          home: const ErrorScreen(),
        );
      }
      return MaterialApp.router(
        theme: themeData,
        routerConfig: router.config(
          deepLinkBuilder: (deepLink) {
            return DeepLink([
              WordSearchRoute(initialSearch: search),
            ]);
          },
        ),
      );
    },
  ));
}
