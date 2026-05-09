import 'package:flutter_test/flutter_test.dart';

import '../../../global/steps/steps.dart';

/// Usage: O usuário abre a aba de configurações
Future<void> oUsuarioAbreAAbaDeConfiguracoes(WidgetTester tester) async {
  await oUsuarioClicaNoComponenteDaKey(tester, 'settings_menu_item_key');
}
