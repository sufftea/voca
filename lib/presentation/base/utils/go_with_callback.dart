import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> goWithCallback(
  BuildContext context,
  String routeName, {
  required VoidCallback onReturn,
  Map<String, String> params = const <String, String>{},
  Map<String, dynamic> queryParams = const <String, dynamic>{},
  Object? extra,
}) async {
  final r = GoRouter.of(context);

  final thisLocation = r.location;

  void listener() async {
    final r = GoRouter.of(context);
    if (r.location != thisLocation) {
      return;
    }

    r.removeListener(listener);

    onReturn();
  }

  r.goNamed(
    routeName,
    params: params,
    queryParams: queryParams,
    extra: extra,
  );

  r.addListener(listener);
}
