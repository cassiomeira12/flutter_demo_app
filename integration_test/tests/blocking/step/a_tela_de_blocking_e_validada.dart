import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: A tela de blocking é validada
Future<void> aTelaDeBlockingEValidada(WidgetTester tester) async {
  expect(find.text('blocking_app_title'.tr), findsOneWidget);
  expect(find.text('blocking_app_message'.tr), findsOneWidget);
}
