import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

import 'o_usuario_faz_scroll_ate_o_componente.dart';

/// Usage: O usuário clica no componente da key {'key'}
Future<void> oUsuarioClicaNoComponenteDaKey(
  WidgetTester tester,
  String key,
) async {
  await oUsuarioFazScrollAteOComponente(tester, key);

  final finder = find.byKey(Key(key));
  expect(finder, findsOneWidget);

  await tester.tap(finder);
  await tester.pumpAndSettle();
}
