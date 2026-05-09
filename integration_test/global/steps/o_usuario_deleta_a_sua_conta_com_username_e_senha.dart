import 'package:flutter_test/flutter_test.dart';

import 'steps.dart';

/// Usage: O usuário deleta a sua conta com username {'username'} e senha {'password'}
Future<void> oUsuarioDeletaASuaContaComUsernameESenha(
  WidgetTester tester,
  String username,
  String password,
) async {
  await oUsuarioAbreAAbaDeConfiguracoes(tester);
  await oUsuarioClicaEm(tester, 'Meus dados');
  await oUsuarioClicaEm(tester, 'Apagar minha conta');
  await oAplicativoEstaNaRota(tester, '/delete_account');
  await oUsuarioClicaNoComponenteDaKey(tester, 'delete_account_reason_1');
  await oBotaoComKeyFicaHabilitado(tester, 'finish_my_account_button_key');
  await oUsuarioClicaEm(tester, 'Encerrar conta');
  await oUsuarioDigitaASuaSenha(tester, password);
  await oAplicativoEstaNaRota(
    tester,
    '/delete_account/finish_account',
  );
  await oUsuarioClicaEm(tester, 'Encerrar conta');
  await oAplicativoEstaNaRota(
    tester,
    '/delete_account/confirmation',
  );
  await oUsuarioClicaEm(tester, 'Encerrar conta');
  await oUsuarioDigitaASuaSenha(tester, password);
  await oAplicativoEstaNaRota(tester, '/delete_account_finished');
  await oUsuarioClicaEm(tester, 'Sair');
  await oAplicativoEstaNaRota(tester, '/login');
  await oUsuarioLogaComUsernameESenha(tester, username, password);
  await oUsuarioVerAMensagem(tester, 'Nome de usuário ou senha incorretos');
  await oUsuarioClicaEm(tester, 'Ok');
}
