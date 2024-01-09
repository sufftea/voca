import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:voca/domain/entities/app_theme.dart';

ThemeData composeTheme(AppTheme appTheme) {
  final colors = switch (appTheme.themeColor) {
    // ThemeColors.orange => FlexScheme.espresso,
    // ThemeColors.blue => FlexScheme.ebonyClay,
    // ThemeColors.green => FlexScheme.green,
    ThemeColors.orange => FlexSchemeColor(
        primary: Colors.brown.shade400,
        secondary: const Color(0xff7f7eff),
      ),
    ThemeColors.blue => FlexSchemeColor(
        primary: const Color(0xff7f7eff),
        secondary: Colors.brown.shade400,
      ),
    ThemeColors.green => const FlexSchemeColor(
        primary: Colors.green,
        secondary: Color.fromARGB(0, 167, 197, 57),
      ),
    /*
    consider: dellGenoa, flutterDash, 
    add: espresso, hippieBlue
    */
  };

  const keyColors = FlexKeyColors(
    keepPrimary: true,
    useSecondary: true,
  );

  return applySharedTheming(appTheme.isDark
      ? FlexThemeData.dark(
          useMaterial3: true,
          colors: colors,
          // scheme: color,
          keyColors: keyColors,
        )
      : FlexColorScheme.light(
          useMaterial3: true,
          colors: colors,
          // scheme: color,
          keyColors: keyColors,
        ).toTheme.copyWith(shadowColor: Colors.black45));
}

ThemeData applySharedTheming(ThemeData theme) {
  return theme.copyWith(
    textTheme: Typography.blackMountainView.apply(),
    //
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      backgroundColor: const MaterialStatePropertyAll(Colors.transparent),
      elevation: const MaterialStatePropertyAll(0),
      padding: const MaterialStatePropertyAll(EdgeInsets.all(6)),
      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      )),
    )),
    cardTheme: CardTheme(
      clipBehavior: Clip.antiAlias,
      elevation: 5,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
    ),
    //
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        elevation: const MaterialStatePropertyAll(0),
        padding: const MaterialStatePropertyAll(EdgeInsets.all(8)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        maximumSize: const MaterialStatePropertyAll(Size.infinite),
        minimumSize: const MaterialStatePropertyAll(Size.zero),
        side: const MaterialStatePropertyAll(BorderSide.none),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
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
        padding: const MaterialStatePropertyAll(EdgeInsets.all(8)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        maximumSize: const MaterialStatePropertyAll(Size.infinite),
        minimumSize: const MaterialStatePropertyAll(Size.zero),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        )),
        textStyle: const MaterialStatePropertyAll(TextStyle(
          fontSize: 20,
          fontWeight: FontWeights.medium,
        )),
        foregroundColor: MaterialStatePropertyAll(theme.colorScheme.onSurface)
      ),
    ),
    timePickerTheme: const TimePickerThemeData(
      hourMinuteTextStyle: TextStyle(
        fontSize: 64,
        fontWeight: FontWeight.w200,
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
