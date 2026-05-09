import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'steps.dart';

/// Usage: O usuário loga com username {'username'} e senha {'password'}
Future<void> oUsuarioLogaComUsernameESenha(
  WidgetTester tester,
  String username,
  String password,
) async {
  expect(AppNavigator.currentRoute, AppRouter.login.name);

  await oUsuarioDigitaNoCampo(tester, username, 'username_input_key');
  await oUsuarioDigitaNoCampo(tester, password, 'password_input_key');
  await oUsuarioClicaNoComponenteDaKey(tester, 'login_button_key');
}
