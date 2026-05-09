import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: O botão com key {'key'} fica habilitado
Future<void> oBotaoComKeyFicaHabilitado(
  WidgetTester tester,
  String key,
) async {
  final buttonFinder = find.byKey(Key(key));
  expect(buttonFinder, findsOneWidget);
  expect(
    (tester.firstWidget(buttonFinder) as PrimaryButton).onPressed != null,
    true,
  );
}
