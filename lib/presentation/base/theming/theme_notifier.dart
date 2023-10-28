import 'package:flutter/material.dart';
import 'package:voca/domain/entities/app_theme.dart';
import 'package:voca/domain/repositories/user_settings_repository.dart';
import 'package:voca/injectable/injectable_init.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeNotifier(AppTheme theme) : _appTheme = theme;

  AppTheme _appTheme;
  AppTheme get appTheme => _appTheme;
  set appTheme(AppTheme value) {
    _appTheme = value;
    getIt.get<UserSettingsRepository>().setTheme(value);

    notifyListeners();
  }
}
