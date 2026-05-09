import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

import 'steps.dart';

/// Usage: O usuário digita {'input'} no campo {'key'}
Future<void> oUsuarioDigitaNoCampo(
  WidgetTester tester,
  String input,
  String key,
) async {
  await oUsuarioClicaNoComponenteDaKey(tester, key);

  final finder = find.byKey(Key(key));
  expect(finder, findsOneWidget);

  await tester.enterText(finder, input);
  await tester.pumpAndSettle();
}
