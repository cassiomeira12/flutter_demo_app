import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: A tela de change password é validada
Future<void> aTelaDeChangePasswordEValidada(WidgetTester tester) async {
  expect(find.text('change_password'.tr), findsOneWidget);

  expect(find.text('password_label'.tr), findsOneWidget);
  expect(find.text('current_password'.tr), findsOneWidget);

  expect(find.text('new_password'.tr), findsOneWidget);
  expect(find.text('create_strong_password'.tr), findsOneWidget);

  expect(find.text('repeat_password'.tr), findsOneWidget);
  expect(find.text('repeat_password_hint'.tr), findsOneWidget);

  expect(find.text('save'.tr), findsOneWidget);
}
