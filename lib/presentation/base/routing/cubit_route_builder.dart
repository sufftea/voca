// DUH..
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voca/presentation/base/utils/cubit_helpers/cubit_provider.dart';

Route<T> Function<T>(
  BuildContext,
  Widget,
  AutoRoutePage<T>,
) cubitRouteBuilder<CubitT extends BlocBase>() {

  Route<T> builder<T>(
    BuildContext context,
    Widget child,
    AutoRoutePage<T> page,
  ) {

    return PageRouteBuilder(
      settings: page,
      pageBuilder: (context, animation, secondaryAnimation) {
        return cubitProvider<CubitT>(child);
      },
    );
  }

  return builder;
}

Route<T> Function<T>(
  BuildContext,
  Widget,
  AutoRoutePage<T>,
) routeBuilder() {
  Route<T> builder<T>(
    BuildContext context,
    Widget child,
    AutoRoutePage<T> page,
  ) {
    return PageRouteBuilder(
      settings: page,
      pageBuilder: (context, animation, secondaryAnimation) {
        return child;
      },
    );
  }

  return builder;
}
