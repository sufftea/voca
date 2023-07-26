import 'package:voca/presentation/base/theming/app_themes.dart';

class ThemeMapper {
  static String toData(AppTheme theme) {
    return theme.name;
  }

  static AppTheme fromData(String? name) {
    return AppTheme.values.firstWhere(
      (element) => element.name == name,
      orElse: () => AppTheme.green,
    );
  }
}
