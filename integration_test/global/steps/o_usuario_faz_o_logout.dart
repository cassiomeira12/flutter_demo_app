import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'steps.dart';

/// Usage: O usuário faz o logout
Future<void> oUsuarioFazOLogout(WidgetTester tester) async {
  await oUsuarioClicaNoComponenteDaKey(tester, 'settings_menu_item_key');
  await oUsuarioClicaNoComponenteDaKey(tester, 'settings_logout_key');
  await oUsuarioClicaNoComponenteDaKey(tester, 'dialog_ok_button_key');

  expect(AppNavigator.currentRoute, AppRouter.login.name);
}
