import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: A tela de settings é validada
Future<void> aTelaDeSettingsEValidada(WidgetTester tester) async {
  final user = AppBinding.find<UserEntity>();

  expect(find.text('Olá, ${user.firstName}'), findsOneWidget);

  expect(find.text('Meus dados'), findsOneWidget);
  expect(find.text('Segurança'), findsOneWidget);
  expect(find.text('Idioma'), findsOneWidget);
  expect(find.text('Temas'), findsOneWidget);
  expect(find.text('Sobre'), findsOneWidget);
  expect(find.text('Limpar cache do aplicativo'), findsOneWidget);

  expect(find.text('Sair'), findsOneWidget);
}
