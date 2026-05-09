import 'package:flutter_test/flutter_test.dart';

import 'steps.dart';

/// Usage: O usuário clica em {'text'}
Future<void> oUsuarioClicaEm(WidgetTester tester, String text) async {
  await oUsuarioFazScrollAteOComponente(tester, text);

  final finder = find.text(text);
  expect(finder, findsOneWidget);

  await tester.tap(finder);
  await tester.pumpAndSettle();
}
