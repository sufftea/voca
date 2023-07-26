import 'package:flutter/material.dart';
import 'package:voca/presentation/base/theming/app_themes.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeNotifier(AppTheme theme) : _appTheme = theme;

  ThemeData get themeData => themes[_appTheme]!;

  AppTheme _appTheme;
  AppTheme get appTheme => _appTheme;
  set appTheme(AppTheme value) {
    _appTheme = value;
    notifyListeners();
  }
}
