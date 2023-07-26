import 'package:voca/domain/entities/app_theme.dart' as domain;
import 'package:voca/presentation/base/theming/app_themes.dart';

class ThemeMapper {
  static domain.AppTheme toData(AppTheme theme) {
    return domain.AppTheme(
      themeName: theme.name.name,
      dark: theme.dark,
    );
  }

  static AppTheme fromData(domain.AppTheme? domainTheme) {
    final name = AppThemeName.values.firstWhere(
      (element) => element.name == domainTheme?.themeName,
      orElse: () => AppThemeName.green,
    );

    return AppTheme(name: name, dark: domainTheme?.dark ?? false);
  }
}
