import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../global/steps/steps.dart';

/// Usage: O usuário valida a permissão <permission> na plataforma {'macOS'} com title <title> e message <message>
Future<void> oUsuarioValidaAPermissaoNaPlataformaComTitleEMessage(
  WidgetTester tester,
  String permission,
  String platform,
  String title,
  String message,
) async {
  switch (permission) {
    case 'appTrackingTransparency':
      if (!Platform.isIOS) {
        await oUsuarioVerAMensagem(tester, 'Concluir');
        await oUsuarioClicaNoComponenteDaKey(tester, 'finish_intro_button_key');
        return;
      }
      await oUsuarioClicaNoComponenteDaKey(tester, 'next_intro_button_key');
      expect(find.text('title_intro_app_tracking'.tr), findsOneWidget);
      expect(find.text('body_intro_app_tracking'.tr), findsOneWidget);
    case 'notification':
      if (Platform.isMacOS) {
        await oUsuarioVerAMensagem(tester, 'Concluir');
        await oUsuarioClicaNoComponenteDaKey(tester, 'finish_intro_button_key');
        return;
      }
      await oUsuarioClicaNoComponenteDaKey(tester, 'next_intro_button_key');
      expect(find.text('title_intro_notification'.tr), findsOneWidget);
      expect(find.text('body_intro_notification'.tr), findsOneWidget);
    case 'location':
      // if (Platform.isMacOS) {
      //   await oUsuarioVerAMensagem(tester, 'Concluir');
      //   await oUsuarioClicaNoComponenteDaKey(tester, 'finish_intro_button_key');
      //   return;
      // }
      await oUsuarioClicaNoComponenteDaKey(tester, 'next_intro_button_key');
      expect(find.text('title_intro_location'.tr), findsOneWidget);
      expect(find.text('body_intro_location'.tr), findsOneWidget);
  }

  await oUsuarioClicaNoComponenteDaKey(tester, 'finish_intro_button_key');

  expect(find.text('Permission.$permission'), findsOneWidget);
  expect(find.text('allow'.tr), findsOneWidget);
  expect(find.text('allow_later'.tr), findsOneWidget);
  await oUsuarioClicaEm(tester, 'allow'.tr);
}
