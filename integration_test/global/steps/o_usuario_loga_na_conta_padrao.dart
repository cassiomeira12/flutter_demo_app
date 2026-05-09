import 'package:flutter_test/flutter_test.dart';

import 'steps.dart';

/// Usage: O usuário loga na conta padrão
Future<void> oUsuarioLogaNaContaPadrao(WidgetTester tester) async {
  const String username = 'teste@email.com';
  const String password = '123456';

  await oUsuarioLogaComUsernameESenha(tester, username, password);
}
