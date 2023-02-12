import 'package:flutter/material.dart';
import 'package:voca/domain/repositories/assets_repository.dart';
import 'package:voca/injectable/injectable_init.dart';
import 'package:voca/presentation/base/base_theme.dart';
import 'package:voca/presentation/base/l10n/strings.g.dart';
import 'package:voca/presentation/base/routing/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();

  configureDependencies();

  final assetsRepository = getIt.get<AssetsRepository>();
  await assetsRepository.loadDatabaseFromAssets();

  runApp(TranslationProvider(
    child: MaterialApp.router(
      theme: baseTheme,
      routerConfig: router,
    ),
  ));
}
