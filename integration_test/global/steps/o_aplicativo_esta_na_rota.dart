import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: O aplicativo está na rota {'/route'}
Future<void> oAplicativoEstaNaRota(WidgetTester tester, String route) async {
  await tester.pumpAndSettle();
  expect(AppNavigator.currentRoute.contains(route), true);
}
