import 'package:flutter_demo_app/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: O aplicativo é inicializado
Future<void> oAplicativoEInicializado(WidgetTester tester) async {
  await tester.pumpWidget(const App());
  await tester.pumpAndSettle();
}
