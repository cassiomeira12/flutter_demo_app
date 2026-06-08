import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class MainListener {
  final MethodChannel _methodChannel;
  final List<NativeListener> _listeners;

  MainListener({
    required this._methodChannel,
    required this._listeners,
  }) {
    _initListeners();
  }

  void _initListeners() {
    _methodChannel.setMethodCallHandler((MethodCall call) async {
      final String method = call.method;
      final arguments = call.arguments;
      for (final listener in _listeners) {
        if (method == listener.method.name) {
          await listener.call(arguments);
        }
      }
    });
  }
}
