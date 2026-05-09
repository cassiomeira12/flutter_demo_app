import 'package:flutter_test/flutter_test.dart';

import 'steps.dart';

/// Usage: O usuário digita a sua senha {'password'}
Future<void> oUsuarioDigitaASuaSenha(
  WidgetTester tester,
  String password,
) async {
  expect(find.text('Valide sua senha'), findsOneWidget);
  await oUsuarioDigitaNoCampo(tester, password, 'password_input_key');
  await oUsuarioClicaNoComponenteDaKey(tester, 'login_button_key');
}
