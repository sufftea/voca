import 'dart:async';

import 'package:flutter/foundation.dart';

typedef OnDataCallback<T> = void Function(T);

abstract class BaseSubject<T> {
  final _controller = StreamController<T>.broadcast();
  final _subscriptions = <OnDataCallback<T>, StreamSubscription>{};

  void add(T value) {
    _controller.add(value);
  }

  void listen(OnDataCallback<T> onData) {
    final subscription = _controller.stream.listen(onData);
    _subscriptions[onData] = subscription;
  }

  void removeListener(OnDataCallback<T> listener) {
    if (_subscriptions[listener] case final s?) {
      s.cancel();
      _subscriptions.remove(listener);
    }
  }
}

abstract class VoidSubject {
  final _callbacks = <VoidCallback>{};

  void notify() {
    for (final callback in _callbacks) {
      callback();
    }
  }

  void listen(VoidCallback onChange) {
    _callbacks.add(onChange);
  }

  void removeListener(VoidCallback listener) {
    _callbacks.remove(listener);
  }
}
