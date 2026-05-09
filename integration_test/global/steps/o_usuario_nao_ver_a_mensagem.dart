import 'package:flutter_test/flutter_test.dart';

/// Usage: O usuário não ver a mensagem {'text'}
Future<void> oUsuarioNaoVerAMensagem(WidgetTester tester, String text) async {
  if (text.isNotEmpty) {
    expect(find.text(text), findsNothing);
  }
}
