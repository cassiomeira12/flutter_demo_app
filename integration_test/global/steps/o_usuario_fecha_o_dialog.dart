import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: O usuário fecha o dialog
Future<void> oUsuarioFechaODialog(WidgetTester tester) async {
  final finder = find.byKey(const Key('dialog_close_icon_key'));
  expect(finder, findsOneWidget);

  await tester.tap(finder);
  await tester.pumpAndSettle();
}
