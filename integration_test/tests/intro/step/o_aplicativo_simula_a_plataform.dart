import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: O aplicativo simula a plataform {'macOS'}
Future<void> oAplicativoSimulaAPlataform(
  WidgetTester tester,
  String platform,
) async {
  Platform.mock(
    TargetPlatform.values.firstWhere((item) {
      return item.name == platform;
    }),
  );
}
