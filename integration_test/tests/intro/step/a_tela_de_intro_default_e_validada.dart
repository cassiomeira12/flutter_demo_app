import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: A tela de intro default é validada
Future<void> aTelaDeIntroDefaultEValidada(WidgetTester tester) async {
  final appEnv = AppBinding.find<AppEnvironmentEntity>();
  expect(find.text(appEnv.appName), findsOneWidget);
  expect(find.text('body_intro_app'.tr), findsOneWidget);
  // if (appEnv.permissions.isEmpty) {
  //   expect(find.text('back_intro'.tr), findsNothing);
  //   expect(find.byKey(const Key('back_intro_button_key')), findsNothing);
  //   expect(find.text('finish_intro'.tr), findsOneWidget);
  //   expect(find.byKey(const Key('finish_intro_button_key')), findsOneWidget);
  // } else {
  //   expect(find.text('next_intro'.tr), findsOneWidget);
  //   expect(find.byKey(const Key('next_intro_button_key')), findsOneWidget);
  // }
}
