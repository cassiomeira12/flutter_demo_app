// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../global/steps/steps.dart';
import 'step/a_tela_de_change_password_e_validada.dart';
import 'step/o_usuario_ver_mensagem_de_sucesso.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('''Change password''', () {
    Future<void> bddSetUp(WidgetTester tester) async {
      await oAppEstaRecemInstalado(tester);
      await oAppEstaComIntroConcluida(tester);
      await asPermissoesForamAceitas(tester);
      await oAplicativoEstaAtualizado(tester);
    }

    testWidgets('''Validar inputs inválidos''', (tester) async {
      await bddSetUp(tester);
      await oAplicativoEInicializado(tester);
      await oUsuarioLogaNaContaPadrao(tester);
      await oUsuarioAbreAAbaDeConfiguracoes(tester);
      await oUsuarioClicaEm(tester, 'Meus dados');
      await oUsuarioClicaEm(tester, 'Alterar senha');
      await oAplicativoEstaNaRota(tester, '/settings/user/change_password');
      await aTelaDeChangePasswordEValidada(tester);
      await oUsuarioDigitaNoCampo(tester, ' ', 'password_input_key');
      await oUsuarioDigitaNoCampo(tester, '123456', 'new_password_input_key');
      await oUsuarioDigitaNoCampo(
        tester,
        '123456',
        'confirm_password_input_key',
      );
      await oUsuarioClicaEm(tester, 'Salvar');
      await oUsuarioVerAMensagem(tester, 'Digite sua senha');
      await oUsuarioDigitaNoCampo(tester, '123456', 'password_input_key');
      await oUsuarioDigitaNoCampo(tester, ' ', 'new_password_input_key');
      await oUsuarioDigitaNoCampo(
        tester,
        '123456',
        'confirm_password_input_key',
      );
      await oUsuarioClicaEm(tester, 'Salvar');
      await oUsuarioVerAMensagem(tester, 'Digite sua senha');
      await oUsuarioDigitaNoCampo(tester, '123456', 'password_input_key');
      await oUsuarioDigitaNoCampo(tester, '123456', 'new_password_input_key');
      await oUsuarioDigitaNoCampo(tester, ' ', 'confirm_password_input_key');
      await oUsuarioClicaEm(tester, 'Salvar');
      await oUsuarioVerAMensagem(tester, 'Digite sua senha');
      await oUsuarioDigitaNoCampo(tester, '123456', 'password_input_key');
      await oUsuarioDigitaNoCampo(tester, '123456', 'new_password_input_key');
      await oUsuarioDigitaNoCampo(
        tester,
        '123456',
        'confirm_password_input_key',
      );
      await oUsuarioClicaEm(tester, 'Salvar');
      await oUsuarioVerAMensagem(
        tester,
        'A nova senha não pode ser igual a atual',
      );
      await oUsuarioDigitaNoCampo(tester, '123456', 'password_input_key');
      await oUsuarioDigitaNoCampo(tester, 'abcde', 'new_password_input_key');
      await oUsuarioDigitaNoCampo(
        tester,
        '123456',
        'confirm_password_input_key',
      );
      await oUsuarioClicaEm(tester, 'Salvar');
      await oUsuarioVerAMensagem(tester, 'As senhas não são iguais');
      await oUsuarioVoltaATela(tester);
      await oAplicativoEstaNaRota(tester, '/settings/user');
      await oUsuarioVoltaATela(tester);
      await oUsuarioFazOLogout(tester);
    });
    testWidgets(
      '''Outline: Altera a senha do usuário ('teste@email.com', '123456', '1234567', '1234567')''',
      (tester) async {
        await bddSetUp(tester);
        await oAplicativoEInicializado(tester);
        await oUsuarioLogaComUsernameESenha(
          tester,
          'teste@email.com',
          '123456',
        );
        await oUsuarioAbreAAbaDeConfiguracoes(tester);
        await oUsuarioClicaEm(tester, 'Meus dados');
        await oUsuarioClicaEm(tester, 'Alterar senha');
        await oAplicativoEstaNaRota(tester, '/settings/user/change_password');
        await aTelaDeChangePasswordEValidada(tester);
        await oUsuarioDigitaNoCampo(tester, '123456', 'password_input_key');
        await oUsuarioDigitaNoCampo(
          tester,
          '1234567',
          'new_password_input_key',
        );
        await oUsuarioDigitaNoCampo(
          tester,
          '1234567',
          'confirm_password_input_key',
        );
        await oUsuarioClicaEm(tester, 'Salvar');
        await oUsuarioVerMensagemDeSucesso(tester);
        await oUsuarioFechaODialog(tester);
        await oAplicativoEstaNaRota(tester, '/settings/user');
        await oUsuarioVoltaATela(tester);
        await oUsuarioFazOLogout(tester);
        await oAplicativoEstaNaRota(tester, '/login');
        await oUsuarioLogaComUsernameESenha(
          tester,
          'teste@email.com',
          '1234567',
        );
        await oUsuarioFazOLogout(tester);
      },
    );
    testWidgets(
      '''Outline: Altera a senha do usuário ('teste@email.com', '1234567', '123456', '123456')''',
      (tester) async {
        await bddSetUp(tester);
        await oAplicativoEInicializado(tester);
        await oUsuarioLogaComUsernameESenha(
          tester,
          'teste@email.com',
          '1234567',
        );
        await oUsuarioAbreAAbaDeConfiguracoes(tester);
        await oUsuarioClicaEm(tester, 'Meus dados');
        await oUsuarioClicaEm(tester, 'Alterar senha');
        await oAplicativoEstaNaRota(tester, '/settings/user/change_password');
        await aTelaDeChangePasswordEValidada(tester);
        await oUsuarioDigitaNoCampo(tester, '1234567', 'password_input_key');
        await oUsuarioDigitaNoCampo(tester, '123456', 'new_password_input_key');
        await oUsuarioDigitaNoCampo(
          tester,
          '123456',
          'confirm_password_input_key',
        );
        await oUsuarioClicaEm(tester, 'Salvar');
        await oUsuarioVerMensagemDeSucesso(tester);
        await oUsuarioFechaODialog(tester);
        await oAplicativoEstaNaRota(tester, '/settings/user');
        await oUsuarioVoltaATela(tester);
        await oUsuarioFazOLogout(tester);
        await oAplicativoEstaNaRota(tester, '/login');
        await oUsuarioLogaComUsernameESenha(
          tester,
          'teste@email.com',
          '123456',
        );
        await oUsuarioFazOLogout(tester);
      },
    );
  });
}
