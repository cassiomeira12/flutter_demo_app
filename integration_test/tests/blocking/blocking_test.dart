// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../global/steps/steps.dart';
import 'step/a_tela_de_blocking_e_validada.dart';
import 'step/o_aplicativo_esta_bloqueado.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('''Blocking App''', () {
    Future<void> bddSetUp(WidgetTester tester) async {
      await oAppEstaRecemInstalado(tester);
      await oAppEstaComIntroConcluida(tester);
      await asPermissoesForamAceitas(tester);
    }

    testWidgets('''Validar o App bloqueado''', (tester) async {
      await bddSetUp(tester);
      await oAplicativoEstaBloqueado(tester);
      await oAplicativoEInicializado(tester);
      await oUsuarioEsperaSegundos(tester, 1);
      await oAplicativoEstaNaRota(tester, '/blocking');
      await aTelaDeBlockingEValidada(tester);
      await oUsuarioEsperaSegundos(tester, 1);
    });
  });
}
