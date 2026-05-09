import 'package:flutter_test/flutter_test.dart';

/// Usage: Validar tela de temas
Future<void> validarTelaDeTemas(WidgetTester tester) async {
  expect(find.text('Temas'), findsOneWidget);

  expect(find.text('Tema'), findsOneWidget);

  expect(find.text('Ícone do App'), findsOneWidget);
  expect(find.text('AppIcon'), findsOneWidget);
  expect(find.text('AppIconDEV'), findsOneWidget);
  expect(find.text('AppIconSTG'), findsOneWidget);
}
