import 'package:flutter_test/flutter_test.dart';

/// Usage: O usuário ver a mensagem {'text'}
Future<void> oUsuarioVerAMensagem(WidgetTester tester, String text) async {
  if (text.isNotEmpty) {
    expect(find.text(text), findsOneWidget);
  }
}
