import 'package:voca/domain/entities/app_theme.dart';

class ThemeMapper {
  static String colorToString(ThemeColors color) {
    return color.name;
  }

  static ThemeColors fromString(String colorString) {
    return ThemeColors.values.firstWhere(
      (element) => element.name == colorString,
      orElse: () => ThemeColors.green,
    );
  }
}
