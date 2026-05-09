import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: O aplicativo não está na rota {'/route'}
Future<void> oAplicativoNaoEstaNaRota(
  WidgetTester tester,
  String route,
) async {
  await tester.pumpAndSettle();
  expect(AppNavigator.currentRoute.contains(route), false);
}
