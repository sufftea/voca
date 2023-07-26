import 'package:flutter/material.dart';

enum AppThemeName {
  green,
  blue,
  orange,
}

class AppTheme {
  const AppTheme({
    this.name = AppThemeName.green,
    this.dark = false,
  });

  final AppThemeName name;
  final bool dark;

  AppTheme copyWith({
    AppThemeName? name,
    bool? dark,
  }) {
    return AppTheme(
      name: name ?? this.name,
      dark: dark ?? this.dark,
    );
  }
}

ThemeData composeTheme(AppTheme theme) {
  return _applyEverythingElse(ThemeData.from(
    colorScheme: ColorScheme.fromSeed(
      seedColor: switch (theme.name) {
        AppThemeName.blue => Colors.lightBlue,
        AppThemeName.green => Colors.lightGreen,
        AppThemeName.orange => Colors.orange,
      },
      shadow: theme.dark ? null : Colors.black26,
      brightness: theme.dark ? Brightness.dark : Brightness.light,
    ),
  ));
}

ThemeData _applyEverythingElse(ThemeData theme) {
  return theme.copyWith(
    useMaterial3: true,
    textTheme: Typography.blackMountainView.apply(),
    //
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      backgroundColor: const MaterialStatePropertyAll(Colors.transparent),
      elevation: const MaterialStatePropertyAll(0),
      padding: const MaterialStatePropertyAll(EdgeInsets.all(5)),
      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      )),
    )),
    cardTheme: CardTheme(
      clipBehavior: Clip.antiAlias,
      elevation: 5,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),
    //
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        elevation: const MaterialStatePropertyAll(0),
        padding: const MaterialStatePropertyAll(EdgeInsets.all(10)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        maximumSize: const MaterialStatePropertyAll(Size.infinite),
        minimumSize: const MaterialStatePropertyAll(Size.zero),
        side: const MaterialStatePropertyAll(BorderSide.none),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        )),
        textStyle: const MaterialStatePropertyAll(TextStyle(
          fontSize: 20,
          fontWeight: FontWeights.medium,
        )),
      ),
    ),
    //
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        padding: const MaterialStatePropertyAll(EdgeInsets.all(10)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        maximumSize: const MaterialStatePropertyAll(Size.infinite),
        minimumSize: const MaterialStatePropertyAll(Size.zero),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        )),
        textStyle: const MaterialStatePropertyAll(TextStyle(
          fontSize: 20,
          fontWeight: FontWeights.medium,
        )),
      ),
    ),
  );
}

class FontWeights {
  const FontWeights._();

  static const thin = FontWeight.w100;
  static const extraLight = FontWeight.w200;
  static const light = FontWeight.w300;

  /// normal/regular
  static const regular = FontWeight.w400;
  static const medium = FontWeight.w500;
  static const semiBold = FontWeight.w600;
  static const bold = FontWeight.w700;
  static const extraBold = FontWeight.w800;
}

MaterialStateProperty<T> mspResolveWith<T>({
  required T none,
  T? disabled,
  T? dragged,
  T? error,
  T? focused,
  T? hovered,
  T? pressed,
  T? scrolledUnder,
  T? selected,
}) {
  return MaterialStateProperty.resolveWith(
    (states) {
      if (states.contains(MaterialState.disabled)) return disabled ?? none;
      if (states.contains(MaterialState.error)) return error ?? none;
      if (states.contains(MaterialState.dragged)) return dragged ?? none;
      if (states.contains(MaterialState.pressed)) return pressed ?? none;
      if (states.contains(MaterialState.focused)) return focused ?? none;
      if (states.contains(MaterialState.hovered)) return hovered ?? none;
      if (states.contains(MaterialState.selected)) return selected ?? none;
      if (states.contains(MaterialState.scrolledUnder)) {
        return scrolledUnder ?? none;
      }
      return none;
    },
  );
}
