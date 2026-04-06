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
          child: SwitchTitleWidget(
            key: const Key('switch_title_widget'),
            text: 'Test Switch Title Widget',
            initialValue: true,
            onChanged: (_) {},
          ),
        ),
      ),
    );
  });

  testWidgets('test switch title widget', (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final switchTitleWidget = find.byKey(const Key('switch_title_widget'));
    expect(switchTitleWidget, findsOneWidget);

    final switchWidget = find.byKey(const Key('switch_widget_key'));
    expect(switchWidget, findsOneWidget);

    expect(find.text('Test Switch Title Widget'), findsOneWidget);

    expect(
      (tester.firstWidget(switchWidget) as SwitchWidget).value,
      true,
    );

    await tester.tap(switchWidget);
    await tester.pumpAndSettle();

    expect(
      (tester.firstWidget(switchWidget) as SwitchWidget).value,
      false,
    );

    await tester.tap(switchWidget);
    await tester.pumpAndSettle();

    expect(
      (tester.firstWidget(switchWidget) as SwitchWidget).value,
      true,
    );
  });
}
