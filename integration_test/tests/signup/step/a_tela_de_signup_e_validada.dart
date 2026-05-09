import 'package:flutter_test/flutter_test.dart';

/// Usage: A tela de signup é validada
Future<void> aTelaDeSignupEValidada(WidgetTester tester) async {
  expect(find.text('Criar conta'), findsNWidgets(2));

  expect(find.text('Nome'), findsOneWidget);
  expect(find.text('Digite seu nome completo'), findsOneWidget);

  expect(find.text('E-mail'), findsOneWidget);
  expect(find.text('Digite seu e-mail aqui'), findsOneWidget);

  expect(find.text('Senha'), findsOneWidget);
  expect(find.text('Crie uma senha forte'), findsOneWidget);

  expect(find.text('Repita a senha'), findsOneWidget);
  expect(find.text('Repita a nova senha'), findsOneWidget);

  expect(
    find.text(
      'Aceito os termos de uso e a política de privacidade.',
      findRichText: true,
    ),
    findsOneWidget,
  );
}
