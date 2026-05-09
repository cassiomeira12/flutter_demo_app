import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: O usuário volta a tela
Future<void> oUsuarioVoltaATela(WidgetTester tester) async {
  await tester.tap(find.byType(BackButton));
  await tester.pumpAndSettle();

  await tester.pumpAndSettle(const Duration(milliseconds: 500));
}
