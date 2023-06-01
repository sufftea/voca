import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

// TODO: get rid of this once again
mixin NavigationObserverMixin<T extends StatefulWidget> on State<T> {
  late final String _myUrl;
  late final AutoRouterDelegate _routerDelegate;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _routerDelegate = AutoRouterDelegate.of(context);

      _myUrl = _routerDelegate.urlState.path;
      _routerDelegate.addListener(_routeListener);

      onNavigatedHere();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _routerDelegate.removeListener(_routeListener);
  }

  void _routeListener() {
    final currPath = _routerDelegate.urlState.path;

    if (currPath == _myUrl) {
      onNavigatedHere();
    }
  }

  /// Called when this screen becomes the top-most on the nav stack
  void onNavigatedHere();
}
