import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

mixin RouteObserverMixin<T extends StatefulWidget> on State<T> {
  late final GoRouter _router;
  late final String _location;

  void onReturnToScreen();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _router = GoRouter.of(context);

      _location = _router.location;

      _router.addListener(_routeListener);
    });
  }

  @override
  void dispose() {
    _router.removeListener(_routeListener);

    super.dispose();
  }

  void _routeListener() {
    if (_router.location == _location) {
      onReturnToScreen();
    }
  }
}
