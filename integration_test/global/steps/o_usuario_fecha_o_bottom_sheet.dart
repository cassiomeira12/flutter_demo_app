import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: O usuário fecha o bottom sheet
Future<void> oUsuarioFechaOBottomSheet(WidgetTester tester) async {
  final finder = find.byKey(const Key('close_button'));
  expect(finder, findsOneWidget);

  await tester.tap(finder);
  await tester.pumpAndSettle();
}
