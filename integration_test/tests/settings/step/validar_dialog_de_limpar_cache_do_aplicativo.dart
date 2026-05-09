import 'package:flutter_test/flutter_test.dart';

/// Usage: Validar dialog de limpar cache do aplicativo
Future<void> validarDialogDeLimparCacheDoAplicativo(WidgetTester tester) async {
  expect(find.text('Deseja limpar os dados?'), findsOneWidget);
  expect(
    find.text(
      'Todos os dados de cache do aplicativo serão apagas, você será deslogado e poderá fazer login novamente.',
    ),
    findsOneWidget,
  );
  expect(find.text('Limpar'), findsOneWidget);
  expect(find.text('Voltar'), findsOneWidget);
}
