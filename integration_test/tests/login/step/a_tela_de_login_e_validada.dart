import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: A tela de login é validada
Future<void> aTelaDeLoginEValidada(WidgetTester tester) async {
  expect(find.text('login'.tr), findsOneWidget);

  expect(find.text('username_label'.tr), findsOneWidget);
  expect(find.text('username_input_hint'.tr), findsOneWidget);

  expect(find.text('password_label'.tr), findsOneWidget);
  expect(find.text('password_input_hint'.tr), findsOneWidget);

  expect(find.text('remember_my_email'.tr), findsOneWidget);
  expect(find.text('login_button'.tr), findsOneWidget);
  expect(find.text('create_new_account'.tr), findsOneWidget);
}
