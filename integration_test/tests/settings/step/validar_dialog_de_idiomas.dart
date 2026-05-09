import 'package:flutter_test/flutter_test.dart';

/// Usage: Validar dialog de idiomas
Future<void> validarDialogDeIdiomas(WidgetTester tester) async {
  expect(find.text('Selecione um idioma'), findsOneWidget);
  expect(find.text('Português'), findsOneWidget);
  expect(find.text('Inglês'), findsOneWidget);
}
