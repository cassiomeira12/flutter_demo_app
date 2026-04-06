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
          child: SwitchWidget(
            key: const Key('switch_widget_key'),
            value: true,
            onChanged: (_) {},
          ),
        ),
      ),
    );
  });

  testWidgets('test switch widget', (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final switchWidget = find.byKey(const Key('switch_widget_key'));
    expect(switchWidget, findsOneWidget);

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
