import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MaterialApp app;

  setUpAll(() {
    app = MaterialApp(
      home: ScaffoldWidget(
        controller: null,
        body: Center(
          child: CheckboxWidget(
            key: const Key('checkbox_widget_key'),
            value: true,
            onChanged: (_) {},
          ),
        ),
      ),
    );
  });

  testWidgets('test checkbox widget', (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final checkboxWidget = find.byKey(const Key('checkbox_widget_key'));
    expect(checkboxWidget, findsOneWidget);

    expect(
      (tester.firstWidget(checkboxWidget) as CheckboxWidget).value,
      true,
    );

    await tester.tap(checkboxWidget);
    await tester.pumpAndSettle();

    expect(
      (tester.firstWidget(checkboxWidget) as CheckboxWidget).value,
      false,
    );

    await tester.tap(checkboxWidget);
    await tester.pumpAndSettle();

    expect(
      (tester.firstWidget(checkboxWidget) as CheckboxWidget).value,
      true,
    );
  });
}
