import 'package:flutter_test/flutter_test.dart';

/// Usage: Validar tela de sobre
Future<void> validarTelaDeSobre(WidgetTester tester) async {
  expect(find.text('Sobre'), findsOneWidget);

  expect(find.text('Avalie o aplicativo'), findsOneWidget);
  expect(find.text('Termos de uso'), findsOneWidget);
  expect(find.text('Política de privacidade'), findsOneWidget);
  expect(find.text('Visitar website'), findsOneWidget);
}
