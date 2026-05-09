import 'package:flutter_test/flutter_test.dart';

/// Usage: Validar dialog de temas
Future<void> validarDialogDeTemas(WidgetTester tester) async {
  expect(find.text('Escolha um tema para o App'), findsOneWidget);

  expect(find.text('Automático'), findsOneWidget);
  expect(find.text('Claro'), findsOneWidget);
  expect(find.text('Escuro'), findsOneWidget);
}
