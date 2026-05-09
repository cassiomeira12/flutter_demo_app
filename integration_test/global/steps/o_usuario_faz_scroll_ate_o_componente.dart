import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: O usuário faz scroll ate o componente {'key' ou 'text}
Future<void> oUsuarioFazScrollAteOComponente(
  WidgetTester tester,
  String component,
) async {
  try {
    expect(find.byKey(Key(component)), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    await tester.dragUntilVisible(
      find.byKey(Key(component)),
      find.byType(SingleChildScrollView),
      Offset.zero,
    );
    await tester.pumpAndSettle();
  } catch (_) {}

  try {
    expect(find.text(component), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    await tester.dragUntilVisible(
      find.text(component),
      find.byType(SingleChildScrollView),
      Offset.zero,
    );
    await tester.pumpAndSettle();
  } catch (_) {}
}
