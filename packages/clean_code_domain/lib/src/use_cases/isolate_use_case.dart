import 'dart:isolate';
import 'package:flutter/foundation.dart';

class IsolateUseCase {
  static Future<T> isolate<T>({required Future<T> Function() builder}) async {
    if (!kIsWeb) {
      return await Isolate.run<T>(() async {
        return await builder.call();
      });
    }
    return builder.call();
  }
}
