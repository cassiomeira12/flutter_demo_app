import 'package:flutter/services.dart';

import 'native_listener.dart';

class MainListener {
  final MethodChannel _methodChannel;
  final List<NativeListener> _listeners;

  MainListener({
    required MethodChannel methodChannel,
    required List<NativeListener> listeners,
  })  : _methodChannel = methodChannel,
        _listeners = listeners {
    _initListeners();
  }

  void _initListeners() {
    _methodChannel.setMethodCallHandler((MethodCall call) async {
      final method = call.method;
      final arguments = call.arguments;
      for (var listener in _listeners) {
        listener.call(method: method, arguments: arguments);
      }
    });
  }
}
