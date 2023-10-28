class AppTheme {
  const AppTheme({
    this.themeColor = ThemeColors.blue,
    this.isDark = false,
  });

  final ThemeColors themeColor;
  final bool isDark;

  AppTheme copyWith({
    ThemeColors? themeColor,
    bool? isDark,
  }) {
    return AppTheme(
      themeColor: themeColor ?? this.themeColor,
      isDark: isDark ?? this.isDark,
    );
  }
}

enum ThemeColors {
  orange, 
  blue, 
  green,
}
