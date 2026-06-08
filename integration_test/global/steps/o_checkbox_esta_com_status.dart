import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: O checkbox {'key'} esta com status {false}
Future<void> oCheckboxEstaComStatus(
  WidgetTester tester,
  String key,
  bool status,
) async {
  final checkboxWidget = find.byKey(Key(key));
  expect(checkboxWidget, findsOneWidget);
  expect(
    (tester.firstWidget(checkboxWidget) as CheckboxWidget).value,
    status,
  );
}
