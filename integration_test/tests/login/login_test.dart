// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../global/steps/steps.dart';
import 'step/a_tela_de_login_e_validada.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('''Login''', () {
    Future<void> bddSetUp(WidgetTester tester) async {
      await oAppEstaRecemInstalado(tester);
      await oAppEstaComIntroConcluida(tester);
      await asPermissoesForamAceitas(tester);
      await oAplicativoEstaAtualizado(tester);
      await oAplicativoEInicializado(tester);
      await oAplicativoEstaNaRota(tester, '/login');
      await aTelaDeLoginEValidada(tester);
    }

    testWidgets(
      '''Outline: Validar inputs inválidos (' ', ' ', 'Digite seu e-mail', 'Digite sua senha')''',
      (tester) async {
        await bddSetUp(tester);
        await oUsuarioDigitaNoCampo(tester, ' ', 'username_input_key');
        await oUsuarioDigitaNoCampo(tester, ' ', 'password_input_key');
        await oUsuarioClicaNoComponenteDaKey(tester, 'login_button_key');
        await oUsuarioVerAMensagem(tester, 'Digite seu e-mail');
        await oUsuarioVerAMensagem(tester, 'Digite sua senha');
      },
    );
    testWidgets(
      '''Outline: Validar inputs inválidos ('fake.com', '123456', 'Digite um e-mail válido', '')''',
      (tester) async {
        await bddSetUp(tester);
        await oUsuarioDigitaNoCampo(tester, 'fake.com', 'username_input_key');
        await oUsuarioDigitaNoCampo(tester, '123456', 'password_input_key');
        await oUsuarioClicaNoComponenteDaKey(tester, 'login_button_key');
        await oUsuarioVerAMensagem(tester, 'Digite um e-mail válido');
        await oUsuarioVerAMensagem(tester, '');
      },
    );
    testWidgets(
      '''Outline: Validar inputs inválidos ('fake@email.com', '123456', 'Nome de usuário ou senha incorretos', 'Ok')''',
      (tester) async {
        await bddSetUp(tester);
        await oUsuarioDigitaNoCampo(
          tester,
          'fake@email.com',
          'username_input_key',
        );
        await oUsuarioDigitaNoCampo(tester, '123456', 'password_input_key');
        await oUsuarioClicaNoComponenteDaKey(tester, 'login_button_key');
        await oUsuarioVerAMensagem(
          tester,
          'Nome de usuário ou senha incorretos',
        );
        await oUsuarioVerAMensagem(tester, 'Ok');
      },
    );
    testWidgets('''Login com sucesso''', (tester) async {
      await bddSetUp(tester);
      await oUsuarioLogaNaContaPadrao(tester);
      await oUsuarioFazOLogout(tester);
    });
    testWidgets('''Fazer login e lembrar meu e-mail''', (tester) async {
      await bddSetUp(tester);
      await oUsuarioClicaNoComponenteDaKey(tester, 'remember_checkbox_key');
      await oCheckboxEstaComStatus(tester, 'remember_checkbox_key', true);
      await oUsuarioLogaNaContaPadrao(tester);
      await oUsuarioFazOLogout(tester);
      await oAplicativoEstaNaRota(tester, '/login');
      await oUsuarioVerAMensagem(tester, 'teste@email.com');
      await oCheckboxEstaComStatus(tester, 'remember_checkbox_key', true);
      await oUsuarioClicaNoComponenteDaKey(tester, 'remember_checkbox_key');
      await oCheckboxEstaComStatus(tester, 'remember_checkbox_key', false);
      await oUsuarioLogaNaContaPadrao(tester);
      await oUsuarioFazOLogout(tester);
      await oAplicativoEstaNaRota(tester, '/login');
      await oUsuarioNaoVerAMensagem(tester, 'teste@email.com');
      await oCheckboxEstaComStatus(tester, 'remember_checkbox_key', false);
    });
  });
}
