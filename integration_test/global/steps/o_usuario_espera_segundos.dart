import 'package:flutter_test/flutter_test.dart';

/// Usage: O usuario espera {seconds} segundos
Future<void> oUsuarioEsperaSegundos(WidgetTester tester, int seconds) async {
  await tester.pumpAndSettle(Duration(seconds: seconds));
  await tester.pumpAndSettle();
}
