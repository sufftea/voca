import 'package:flutter/material.dart';

class BaseColors {
  const BaseColors._();

  static const white = Colors.white;
  static final white10 = Colors.white.withOpacity(0.1);
  static final white80 = Colors.white.withOpacity(0.8);
  static const black = Colors.black;
  static final black10 = Colors.black.withOpacity(0.1);
  static final black25 = Colors.black.withOpacity(0.25);
  static const mineShaft = Color(0xff2e2e2e);
  static final mineShaft10 = mineShaft.withOpacity(0.10);
  static const mercury = Color(0xffE9E9E9);
  static const concrete = Color(0xfff3f3f3);
  static const curiousBlue = Color(0xff1E88E5);
  static final curiousBlue10 = curiousBlue.withOpacity(0.1);
  static const neptune = Color(0xff7EACBA);
  static const bittersweet = Color(0xffFF6060);
  static final bittersweet10 = bittersweet.withOpacity(0.1);
}

final baseTheme = ThemeData(
  useMaterial3: true,
  primarySwatch: Colors.blue,
  //
  textTheme: Typography.blackMountainView.apply(
    bodyColor: BaseColors.mineShaft,
    displayColor: BaseColors.mineShaft,
  ),
  //
  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
    backgroundColor: const MaterialStatePropertyAll(Colors.transparent),
    overlayColor: MaterialStatePropertyAll(BaseColors.curiousBlue10),
    elevation: const MaterialStatePropertyAll(0),
    padding: const MaterialStatePropertyAll(EdgeInsets.all(5)),
    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    )),
    foregroundColor: const MaterialStatePropertyAll(BaseColors.mineShaft),
  )),
  //
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      backgroundColor: const MaterialStatePropertyAll(BaseColors.curiousBlue),
      elevation: const MaterialStatePropertyAll(0),
      padding: const MaterialStatePropertyAll(EdgeInsets.all(10)),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      maximumSize: const MaterialStatePropertyAll(Size.infinite),
      minimumSize: const MaterialStatePropertyAll(Size.zero),
      side: const MaterialStatePropertyAll(BorderSide.none),
      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      )),
      foregroundColor: const MaterialStatePropertyAll(BaseColors.white),
      textStyle: const MaterialStatePropertyAll(TextStyle(
        fontSize: 20,
        fontWeight: FontWeights.medium,
      )),
    ),
  ),
);

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
