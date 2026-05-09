// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../global/steps/steps.dart';
import 'step/a_tela_de_force_update_e_validada.dart';
import 'step/a_tela_de_update_available_e_validada.dart';
import 'step/o_aplicativo_possui_uma_atualizacao_bloqueante.dart';
import 'step/o_aplicativo_possui_uma_atualizacao_nao_bloqueante.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('''Update App''', () {
    Future<void> bddSetUp(WidgetTester tester) async {
      await oAppEstaRecemInstalado(tester);
      await oAppEstaComIntroConcluida(tester);
      await asPermissoesForamAceitas(tester);
    }

    testWidgets('''Validar atualização disponível não bloqueante''', (
      tester,
    ) async {
      await bddSetUp(tester);
      await oAplicativoPossuiUmaAtualizacaoNaoBloqueante(tester);
      await oAplicativoEInicializado(tester);
      await oUsuarioEsperaSegundos(tester, 1);
      await oAplicativoEstaNaRota(tester, '/update');
      await aTelaDeUpdateAvailableEValidada(tester);
      await oUsuarioEsperaSegundos(tester, 1);
      await oUsuarioClicaNoComponenteDaKey(tester, 'update_later_button_key');
      await oAplicativoNaoEstaNaRota(tester, '/update');
      await oUsuarioEsperaSegundos(tester, 1);
    });
    testWidgets('''Validar atualização disponível bloqueante''', (
      tester,
    ) async {
      await bddSetUp(tester);
      await oAplicativoPossuiUmaAtualizacaoBloqueante(tester);
      await oAplicativoEInicializado(tester);
      await oUsuarioEsperaSegundos(tester, 1);
      await oAplicativoEstaNaRota(tester, '/force_update');
      await aTelaDeForceUpdateEValidada(tester);
      await oUsuarioEsperaSegundos(tester, 1);
    });
  });
}
