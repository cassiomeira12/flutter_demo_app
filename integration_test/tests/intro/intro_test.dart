// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../global/steps/steps.dart';
import 'step/a_tela_de_intro_default_e_validada.dart';
import 'step/o_aplicativo_nao_possui_permissoes.dart';
import 'step/o_aplicativo_possui_as_persmissoes.dart';
import 'step/o_aplicativo_simula_a_plataform.dart';
import 'step/o_usuario_valida_a_permissao_na_plataforma_com_title_e_message.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('''Intro''', () {
    Future<void> bddSetUp(WidgetTester tester) async {
      await oAppEstaRecemInstalado(tester);
    }

    testWidgets('''Validar páginas de intro sem permissões''', (tester) async {
      await bddSetUp(tester);
      await oAplicativoNaoPossuiPermissoes(tester);
      await oAplicativoEInicializado(tester);
      await oAplicativoEstaNaRota(tester, '/intro');
      await aTelaDeIntroDefaultEValidada(tester);
      await oUsuarioNaoVerAMensagem(tester, 'Voltar');
      await oUsuarioNaoVerAMensagem(tester, 'Próximo');
      await oUsuarioVerAMensagem(tester, 'Concluir');
      await oUsuarioClicaNoComponenteDaKey(tester, 'finish_intro_button_key');
      await oAplicativoNaoEstaNaRota(tester, '/intro');
    });
    testWidgets(
      '''Outline: Validar páginas de intro no Android ('appTrackingTransparency', 'title_intro_app_tracking', 'body_intro_app_tracking')''',
      (tester) async {
        await bddSetUp(tester);
        await oAplicativoSimulaAPlataform(tester, 'android');
        await oAplicativoPossuiAsPersmissoes(tester, 'appTrackingTransparency');
        await oAplicativoEInicializado(tester);
        await oAplicativoEstaNaRota(tester, '/intro');
        await aTelaDeIntroDefaultEValidada(tester);
        await oUsuarioNaoVerAMensagem(tester, 'Voltar');
        await oUsuarioValidaAPermissaoNaPlataformaComTitleEMessage(
          tester,
          'appTrackingTransparency',
          'android',
          'title_intro_app_tracking',
          'body_intro_app_tracking',
        );
        await oAplicativoNaoEstaNaRota(tester, '/intro');
      },
    );
    testWidgets(
      '''Outline: Validar páginas de intro no Android ('notification', 'title_intro_notification', 'body_intro_notification')''',
      (tester) async {
        await bddSetUp(tester);
        await oAplicativoSimulaAPlataform(tester, 'android');
        await oAplicativoPossuiAsPersmissoes(tester, 'notification');
        await oAplicativoEInicializado(tester);
        await oAplicativoEstaNaRota(tester, '/intro');
        await aTelaDeIntroDefaultEValidada(tester);
        await oUsuarioNaoVerAMensagem(tester, 'Voltar');
        await oUsuarioValidaAPermissaoNaPlataformaComTitleEMessage(
          tester,
          'notification',
          'android',
          'title_intro_notification',
          'body_intro_notification',
        );
        await oAplicativoNaoEstaNaRota(tester, '/intro');
      },
    );
    testWidgets(
      '''Outline: Validar páginas de intro no Android ('location', 'title_intro_location', 'body_intro_location')''',
      (tester) async {
        await bddSetUp(tester);
        await oAplicativoSimulaAPlataform(tester, 'android');
        await oAplicativoPossuiAsPersmissoes(tester, 'location');
        await oAplicativoEInicializado(tester);
        await oAplicativoEstaNaRota(tester, '/intro');
        await aTelaDeIntroDefaultEValidada(tester);
        await oUsuarioNaoVerAMensagem(tester, 'Voltar');
        await oUsuarioValidaAPermissaoNaPlataformaComTitleEMessage(
          tester,
          'location',
          'android',
          'title_intro_location',
          'body_intro_location',
        );
        await oAplicativoNaoEstaNaRota(tester, '/intro');
      },
    );
    testWidgets(
      '''Outline: Validar páginas de intro no iOS ('appTrackingTransparency', 'title_intro_app_tracking', 'body_intro_app_tracking')''',
      (tester) async {
        await bddSetUp(tester);
        await oAplicativoSimulaAPlataform(tester, 'iOS');
        await oAplicativoPossuiAsPersmissoes(tester, 'appTrackingTransparency');
        await oAplicativoEInicializado(tester);
        await oAplicativoEstaNaRota(tester, '/intro');
        await aTelaDeIntroDefaultEValidada(tester);
        await oUsuarioNaoVerAMensagem(tester, 'Voltar');
        await oUsuarioValidaAPermissaoNaPlataformaComTitleEMessage(
          tester,
          'appTrackingTransparency',
          'iOS',
          'title_intro_app_tracking',
          'body_intro_app_tracking',
        );
        await oAplicativoNaoEstaNaRota(tester, '/intro');
      },
    );
    testWidgets(
      '''Outline: Validar páginas de intro no iOS ('notification', 'title_intro_notification', 'body_intro_notification')''',
      (tester) async {
        await bddSetUp(tester);
        await oAplicativoSimulaAPlataform(tester, 'iOS');
        await oAplicativoPossuiAsPersmissoes(tester, 'notification');
        await oAplicativoEInicializado(tester);
        await oAplicativoEstaNaRota(tester, '/intro');
        await aTelaDeIntroDefaultEValidada(tester);
        await oUsuarioNaoVerAMensagem(tester, 'Voltar');
        await oUsuarioValidaAPermissaoNaPlataformaComTitleEMessage(
          tester,
          'notification',
          'iOS',
          'title_intro_notification',
          'body_intro_notification',
        );
        await oAplicativoNaoEstaNaRota(tester, '/intro');
      },
    );
    testWidgets(
      '''Outline: Validar páginas de intro no iOS ('location', 'title_intro_location', 'body_intro_location')''',
      (tester) async {
        await bddSetUp(tester);
        await oAplicativoSimulaAPlataform(tester, 'iOS');
        await oAplicativoPossuiAsPersmissoes(tester, 'location');
        await oAplicativoEInicializado(tester);
        await oAplicativoEstaNaRota(tester, '/intro');
        await aTelaDeIntroDefaultEValidada(tester);
        await oUsuarioNaoVerAMensagem(tester, 'Voltar');
        await oUsuarioValidaAPermissaoNaPlataformaComTitleEMessage(
          tester,
          'location',
          'iOS',
          'title_intro_location',
          'body_intro_location',
        );
        await oAplicativoNaoEstaNaRota(tester, '/intro');
      },
    );
    testWidgets(
      '''Outline: Validar páginas de intro no macOS ('appTrackingTransparency', 'title_intro_app_tracking', 'body_intro_app_tracking')''',
      (tester) async {
        await bddSetUp(tester);
        await oAplicativoSimulaAPlataform(tester, 'macOS');
        await oAplicativoPossuiAsPersmissoes(tester, 'appTrackingTransparency');
        await oAplicativoEInicializado(tester);
        await oAplicativoEstaNaRota(tester, '/intro');
        await aTelaDeIntroDefaultEValidada(tester);
        await oUsuarioNaoVerAMensagem(tester, 'Voltar');
        await oUsuarioValidaAPermissaoNaPlataformaComTitleEMessage(
          tester,
          'appTrackingTransparency',
          'macOS',
          'title_intro_app_tracking',
          'body_intro_app_tracking',
        );
        await oAplicativoNaoEstaNaRota(tester, '/intro');
      },
    );
    testWidgets(
      '''Outline: Validar páginas de intro no macOS ('notification', 'title_intro_notification', 'body_intro_notification')''',
      (tester) async {
        await bddSetUp(tester);
        await oAplicativoSimulaAPlataform(tester, 'macOS');
        await oAplicativoPossuiAsPersmissoes(tester, 'notification');
        await oAplicativoEInicializado(tester);
        await oAplicativoEstaNaRota(tester, '/intro');
        await aTelaDeIntroDefaultEValidada(tester);
        await oUsuarioNaoVerAMensagem(tester, 'Voltar');
        await oUsuarioValidaAPermissaoNaPlataformaComTitleEMessage(
          tester,
          'notification',
          'macOS',
          'title_intro_notification',
          'body_intro_notification',
        );
        await oAplicativoNaoEstaNaRota(tester, '/intro');
      },
    );
    testWidgets(
      '''Outline: Validar páginas de intro no macOS ('location', 'title_intro_location', 'body_intro_location')''',
      (tester) async {
        await bddSetUp(tester);
        await oAplicativoSimulaAPlataform(tester, 'macOS');
        await oAplicativoPossuiAsPersmissoes(tester, 'location');
        await oAplicativoEInicializado(tester);
        await oAplicativoEstaNaRota(tester, '/intro');
        await aTelaDeIntroDefaultEValidada(tester);
        await oUsuarioNaoVerAMensagem(tester, 'Voltar');
        await oUsuarioValidaAPermissaoNaPlataformaComTitleEMessage(
          tester,
          'location',
          'macOS',
          'title_intro_location',
          'body_intro_location',
        );
        await oAplicativoNaoEstaNaRota(tester, '/intro');
      },
    );
    testWidgets(
      '''Validar que ao retornar para tela de permissão o dialog não é exibido antes da transição de página''',
      (tester) async {
        await bddSetUp(tester);
        await oAplicativoSimulaAPlataform(tester, 'android');
        await oAplicativoPossuiAsPersmissoes(tester, 'location');
        await oAplicativoEInicializado(tester);
        await oAplicativoEstaNaRota(tester, '/intro');
        await aTelaDeIntroDefaultEValidada(tester);
        await oUsuarioClicaNoComponenteDaKey(tester, 'next_intro_button_key');
        await oUsuarioVerAMensagem(tester, 'Localização');
        await oUsuarioNaoVerAMensagem(tester, 'Permission.location');
        await oUsuarioClicaNoComponenteDaKey(tester, 'back_intro_button_key');
        await aTelaDeIntroDefaultEValidada(tester);
        await oUsuarioClicaNoComponenteDaKey(tester, 'next_intro_button_key');
        await oUsuarioVerAMensagem(tester, 'Localização');
        await oUsuarioNaoVerAMensagem(tester, 'Permission.location');
        await oUsuarioClicaNoComponenteDaKey(tester, 'finish_intro_button_key');
        await oUsuarioVerAMensagem(tester, 'Permission.location');
        await oUsuarioVerAMensagem(tester, 'Permitir');
        await oUsuarioVerAMensagem(tester, 'Agora não');
      },
    );
  });
}
