import 'package:dependency/dependency.dart';
import 'package:dependency/dependency.dart' as path;
import 'package:flutter_test/flutter_test.dart';

abstract class MockMethodHandler {
  static void getApplicationDocumentsDirectory() {
    const channel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          channel,
          (message) async {
            if (message.method == 'getApplicationDocumentsDirectory') {
              return path.join(Directory.current.path, 'build', 'mock_storage');
            }
            return null;
          },
        );
  }
}
