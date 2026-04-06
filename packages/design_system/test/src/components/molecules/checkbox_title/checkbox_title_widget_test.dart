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
          child: CheckboxTitleWidget(
            customKey: const Key('checkbox_title_widget'),
            text: 'Test Checkbox Title Widget',
            onChanged: (_) {},
          ),
        ),
      ),
    );
  });

  testWidgets('test checkbox title widget', (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final checkboxTitleWidget = find.byKey(const Key('checkbox_title_widget'));
    expect(checkboxTitleWidget, findsOneWidget);

    expect(find.text('Test Checkbox Title Widget'), findsOneWidget);

    expect(
      (tester.firstWidget(checkboxTitleWidget) as CheckboxWidget).value,
      false,
    );

    await tester.tap(checkboxTitleWidget);
    await tester.pumpAndSettle();

    expect(
      (tester.firstWidget(checkboxTitleWidget) as CheckboxWidget).value,
      true,
    );

    await tester.tap(checkboxTitleWidget);
    await tester.pumpAndSettle();

    expect(
      (tester.firstWidget(checkboxTitleWidget) as CheckboxWidget).value,
      false,
    );
  });
}
