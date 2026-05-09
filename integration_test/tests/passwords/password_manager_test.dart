// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../global/steps/steps.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('''Password Manager''', () {
    Future<void> bddSetUp(WidgetTester tester) async {
      await oAppEstaRecemInstalado(tester);
      await oAppEstaComIntroConcluida(tester);
      await asPermissoesForamAceitas(tester);
      await oAplicativoEstaAtualizado(tester);
      await oAplicativoEInicializado(tester);
      await oUsuarioLogaNaContaPadrao(tester);
    }

    testWidgets('''Criar, visualizar e remover uma senha''', (tester) async {
      await bddSetUp(tester);
      await oUsuarioClicaNoComponenteDaKey(
        tester,
        'add_new_credential_button_key',
      );
      await oAplicativoEstaNaRota(tester, '/credentials/credential');
      await oUsuarioDigitaNoCampo(
        tester,
        'NovaSenha',
        'credential_name_input_key',
      );
      await oUsuarioDigitaNoCampo(tester, 'Usuario', 'username_input_key');
      await oUsuarioDigitaNoCampo(tester, 'Senha', 'password_input_key');
      await oUsuarioClicaNoComponenteDaKey(
        tester,
        'save_credential_button_key',
      );
      await oAplicativoEstaNaRota(tester, '/credentials');
      await oUsuarioVerAMensagem(tester, 'NovaSenha');
      await oUsuarioClicaEm(tester, 'NovaSenha');
      await oUsuarioClicaNoComponenteDaKey(
        tester,
        'popup_menu_key',
      );
      await oUsuarioClicaEm(tester, 'Remover');
      await oUsuarioNaoVerAMensagem(tester, 'NovaSenha');
      await oUsuarioFazOLogout(tester);
    });
    testWidgets('''Editar uma senha existente''', (tester) async {
      await bddSetUp(tester);
      await oUsuarioClicaNoComponenteDaKey(
        tester,
        'add_new_credential_button_key',
      );
      await oAplicativoEstaNaRota(tester, '/credentials/credential');
      await oUsuarioDigitaNoCampo(
        tester,
        'SenhaEditavel',
        'credential_name_input_key',
      );
      await oUsuarioDigitaNoCampo(tester, 'Usuario', 'username_input_key');
      await oUsuarioDigitaNoCampo(tester, 'Senha', 'password_input_key');
      await oUsuarioClicaNoComponenteDaKey(
        tester,
        'save_credential_button_key',
      );
      await oAplicativoEstaNaRota(tester, '/credentials');
      await oUsuarioVerAMensagem(tester, 'SenhaEditavel');
      await oUsuarioClicaEm(tester, 'SenhaEditavel');
      await oUsuarioDigitaNoCampo(
        tester,
        'SenhaEditada',
        'credential_name_input_key',
      );
      await oUsuarioDigitaNoCampo(
        tester,
        'UsuarioEditado',
        'username_input_key',
      );
      await oUsuarioDigitaNoCampo(tester, 'SenhaEditada', 'password_input_key');
      await oUsuarioClicaNoComponenteDaKey(
        tester,
        'save_credential_button_key',
      );
      await oAplicativoEstaNaRota(tester, '/credentials');
      await oUsuarioVerAMensagem(tester, 'SenhaEditada');
      await oUsuarioNaoVerAMensagem(tester, 'SenhaEditavel');
      await oUsuarioClicaEm(tester, 'SenhaEditada');
      await oUsuarioClicaNoComponenteDaKey(
        tester,
        'popup_menu_key',
      );
      await oUsuarioClicaEm(tester, 'Remover');
      await oUsuarioNaoVerAMensagem(tester, 'SenhaEditavel');
      await oUsuarioFazOLogout(tester);
    });
  });
}
