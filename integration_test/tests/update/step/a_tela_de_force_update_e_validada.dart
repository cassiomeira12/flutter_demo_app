import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: A tela de force update é validada
Future<void> aTelaDeForceUpdateEValidada(WidgetTester tester) async {
  expect(find.text('update_app'.tr), findsOneWidget);
  expect(find.text('new_version_app'.tr), findsOneWidget);
  expect(find.text('new_version_app_message'.tr), findsOneWidget);
  expect(find.text('update_now_button'.tr), findsOneWidget);
  expect(find.text('update_later_button'.tr), findsNothing);
}
