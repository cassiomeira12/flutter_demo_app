import 'package:flutter_test/flutter_test.dart';

/// Usage: Validar tela de segurança
Future<void> validarTelaDeSeguranca(WidgetTester tester) async {
  expect(find.text('Segurança'), findsOneWidget);

  expect(find.text('Biometria desativada'), findsOneWidget);
  expect(
    find.text(
      'Com a biometria ativada o App ficará mais seguro e só você poderá acessar o aplicativo.',
    ),
    findsOneWidget,
  );
}
