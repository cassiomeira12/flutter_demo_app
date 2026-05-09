// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../global/steps/steps.dart';
import 'step/a_tela_de_signup_e_validada.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('''Signup''', () {
    Future<void> bddSetUp(WidgetTester tester) async {
      await oAppEstaRecemInstalado(tester);
      await oAppEstaComIntroConcluida(tester);
      await asPermissoesForamAceitas(tester);
      await oAplicativoEstaAtualizado(tester);
      await oAplicativoEInicializado(tester);
      await oAplicativoEstaNaRota(tester, '/login');
      await oUsuarioClicaEm(tester, 'Criar uma conta');
      await oAplicativoEstaNaRota(tester, '/signup');
      await aTelaDeSignupEValidada(tester);
    }

    testWidgets('''Validar aceite de termos''', (tester) async {
      await bddSetUp(tester);
      await oUsuarioDigitaNoCampo(tester, 'Faker', 'name_input_key');
      await oUsuarioDigitaNoCampo(tester, 'faker@email.com', 'email_input_key');
      await oUsuarioDigitaNoCampo(tester, '123456', 'password_input_key');
      await oUsuarioDigitaNoCampo(
        tester,
        '123456',
        'confirm_password_input_key',
      );
      await oUsuarioClicaNoComponenteDaKey(tester, 'signup_button_key');
      await oUsuarioVerAMensagem(
        tester,
        'Você precisa aceitar os termos e a política de privacidade',
      );
    });
    testWidgets(
      '''Outline: Validar inputs inválidos (' ', ' ', ' ', '1', 'Digite seu nome', 'Digite seu e-mail', 'Digite sua senha', 'As senhas não são iguais')''',
      (tester) async {
        await bddSetUp(tester);
        await oUsuarioDigitaNoCampo(tester, ' ', 'name_input_key');
        await oUsuarioDigitaNoCampo(tester, ' ', 'email_input_key');
        await oUsuarioDigitaNoCampo(tester, ' ', 'password_input_key');
        await oUsuarioDigitaNoCampo(tester, '1', 'confirm_password_input_key');
        await oUsuarioClicaNoComponenteDaKey(tester, 'signup_button_key');
        await oUsuarioVerAMensagem(tester, 'Digite seu nome');
        await oUsuarioVerAMensagem(tester, 'Digite seu e-mail');
        await oUsuarioVerAMensagem(tester, 'Digite sua senha');
        await oUsuarioVerAMensagem(tester, 'As senhas não são iguais');
      },
    );
    testWidgets(
      '''Outline: Validar inputs inválidos ('Teste', 'teste.com', '123456', ' ', '', 'Digite um e-mail válido', '', 'Digite sua senha')''',
      (tester) async {
        await bddSetUp(tester);
        await oUsuarioDigitaNoCampo(tester, 'Teste', 'name_input_key');
        await oUsuarioDigitaNoCampo(tester, 'teste.com', 'email_input_key');
        await oUsuarioDigitaNoCampo(tester, '123456', 'password_input_key');
        await oUsuarioDigitaNoCampo(tester, ' ', 'confirm_password_input_key');
        await oUsuarioClicaNoComponenteDaKey(tester, 'signup_button_key');
        await oUsuarioVerAMensagem(tester, '');
        await oUsuarioVerAMensagem(tester, 'Digite um e-mail válido');
        await oUsuarioVerAMensagem(tester, '');
        await oUsuarioVerAMensagem(tester, 'Digite sua senha');
      },
    );
    testWidgets(
      '''Outline: Validar inputs inválidos ('Teste', 'teste@email.com', '123456', '123456', '', '', '', '')''',
      (tester) async {
        await bddSetUp(tester);
        await oUsuarioDigitaNoCampo(tester, 'Teste', 'name_input_key');
        await oUsuarioDigitaNoCampo(
          tester,
          'teste@email.com',
          'email_input_key',
        );
        await oUsuarioDigitaNoCampo(tester, '123456', 'password_input_key');
        await oUsuarioDigitaNoCampo(
          tester,
          '123456',
          'confirm_password_input_key',
        );
        await oUsuarioClicaNoComponenteDaKey(tester, 'signup_button_key');
        await oUsuarioVerAMensagem(tester, '');
        await oUsuarioVerAMensagem(tester, '');
        await oUsuarioVerAMensagem(tester, '');
        await oUsuarioVerAMensagem(tester, '');
      },
    );
    testWidgets('''Criar conta de usuário e depois deletar conta''', (
      tester,
    ) async {
      await bddSetUp(tester);
      await oUsuarioDigitaNoCampo(tester, 'Faker', 'name_input_key');
      await oUsuarioDigitaNoCampo(tester, 'faker@email.com', 'email_input_key');
      await oUsuarioDigitaNoCampo(tester, '123456', 'password_input_key');
      await oUsuarioDigitaNoCampo(
        tester,
        '123456',
        'confirm_password_input_key',
      );
      await oUsuarioClicaNoComponenteDaKey(
        tester,
        'accept_terms_and_policy_checkbox_widget_key',
      );
      await oUsuarioClicaNoComponenteDaKey(tester, 'signup_button_key');
      await oUsuarioDeletaASuaContaComUsernameESenha(
        tester,
        'fake@email.com',
        '123456',
      );
    });
  });
}
