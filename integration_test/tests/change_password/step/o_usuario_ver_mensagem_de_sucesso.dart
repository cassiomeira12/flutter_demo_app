import 'package:flutter_test/flutter_test.dart';

/// Usage: O usuário ver mensagem de sucesso
Future<void> oUsuarioVerMensagemDeSucesso(WidgetTester tester) async {
  expect(find.text('Senha alterada'), findsOneWidget);
  expect(find.text('Sua senha foi alterada com sucesso!'), findsOneWidget);
  expect(find.text('Ok'), findsOneWidget);
}
