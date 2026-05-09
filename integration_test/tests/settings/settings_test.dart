// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../global/steps/steps.dart';
import 'step/a_tela_de_settings_e_validada.dart';
import 'step/validar_dialog_de_idiomas.dart';
import 'step/validar_dialog_de_limpar_cache_do_aplicativo.dart';
import 'step/validar_dialog_de_temas.dart';
import 'step/validar_tela_de_dados_do_usuario.dart';
import 'step/validar_tela_de_seguranca.dart';
import 'step/validar_tela_de_sobre.dart';
import 'step/validar_tela_de_temas.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('''Settings''', () {
    Future<void> bddSetUp(WidgetTester tester) async {
      await oAppEstaRecemInstalado(tester);
      await oAppEstaComIntroConcluida(tester);
      await oAplicativoEstaAtualizado(tester);
      await oAplicativoEInicializado(tester);
      await oUsuarioLogaNaContaPadrao(tester);
      await oUsuarioAbreAAbaDeConfiguracoes(tester);
    }

    testWidgets('''Validar tela de configurações''', (tester) async {
      await bddSetUp(tester);
      await oAplicativoEstaNaRota(tester, '/settings');
      await aTelaDeSettingsEValidada(tester);
      await oUsuarioClicaEm(tester, 'Meus dados');
      await validarTelaDeDadosDoUsuario(tester);
      await oUsuarioVoltaATela(tester);
      await oUsuarioClicaEm(tester, 'Segurança');
      await validarTelaDeSeguranca(tester);
      await oUsuarioVoltaATela(tester);
      await oUsuarioClicaEm(tester, 'Idioma');
      await validarDialogDeIdiomas(tester);
      await oUsuarioFechaOBottomSheet(tester);
      await oUsuarioClicaEm(tester, 'Temas');
      await validarTelaDeTemas(tester);
      await oUsuarioClicaEm(tester, 'Tema');
      await validarDialogDeTemas(tester);
      await oUsuarioFechaOBottomSheet(tester);
      await oUsuarioVoltaATela(tester);
      await oUsuarioClicaEm(tester, 'Sobre');
      await validarTelaDeSobre(tester);
      await oUsuarioVoltaATela(tester);
      await oUsuarioClicaEm(tester, 'Limpar cache do aplicativo');
      await validarDialogDeLimparCacheDoAplicativo(tester);
      await oUsuarioFechaOBottomSheet(tester);
      await oUsuarioFazOLogout(tester);
    });
  });
}
