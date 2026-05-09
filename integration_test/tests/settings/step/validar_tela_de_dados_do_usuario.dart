import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: Validar tela de dados do usuário
Future<void> validarTelaDeDadosDoUsuario(WidgetTester tester) async {
  expect(find.text('Meus dados'), findsOneWidget);

  expect(find.text('Alterar foto'), findsOneWidget);
  expect(find.text('Nome'), findsOneWidget);
  expect(find.text('E-mail'), findsOneWidget);
  expect(find.text('Alterar senha'), findsOneWidget);
  expect(find.text('Apagar minha conta'), findsOneWidget);

  final user = AppBinding.find<UserEntity>();
  expect(find.text(user.name), findsOneWidget);
  expect(find.text(user.email), findsOneWidget);
}
