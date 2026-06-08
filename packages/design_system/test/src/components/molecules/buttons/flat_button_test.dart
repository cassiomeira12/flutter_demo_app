import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class MockOnPressed extends Mock {
  void call();
}

class MockIconWidget extends StatelessWidget {
  const MockIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.star, key: Key('mock_icon'));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MockOnPressed? mockOnPressed;

  setUpAll(() {
    AppBinding.testMode(true);
    ThemeManager().defineColor(
      lightColorScheme: LightColorScheme(color: Colors.blue),
      darkColorScheme: DarkColorScheme(color: Colors.blue),
    );
  });

  setUp(() {
    mockOnPressed = MockOnPressed();
  });

  Widget buildApp(Widget child) {
    return MaterialApp(
      theme: ThemeManager().lightTheme,
      home: Scaffold(
        body: Center(child: child),
      ),
    );
  }

  group('Renderização', () {
    testWidgets(
      'deve renderizar com o texto especificado',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            FlatButton(
              text: 'Salvar',
              onPressed: mockOnPressed!.call,
            ),
          ),
        );

        expect(find.text('Salvar'), findsOneWidget);
      },
    );

    testWidgets(
      'deve renderizar sem texto quando text é null',
      (tester) async {
        await tester.pumpWidget(
          buildApp(const FlatButton()),
        );

        final textWidget = tester.widget<TextWidget>(
          find.byType(TextWidget),
        );
        expect(textWidget.text, isEmpty);
      },
    );

    testWidgets(
      'deve renderizar ícone quando fornecido',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            FlatButton(
              text: 'Salvar',
              icon: const MockIconWidget(),
              onPressed: mockOnPressed!.call,
            ),
          ),
        );

        expect(find.byKey(const Key('mock_icon')), findsOneWidget);
      },
    );

    testWidgets(
      'deve expandir largura quando expandWidth é true',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            FlatButton(
              text: 'Salvar',
              onPressed: mockOnPressed!.call,
              expandWidth: true,
            ),
          ),
        );

        final row = tester.widget<Row>(find.byType(Row));
        expect(row.mainAxisSize, MainAxisSize.max);
      },
    );

    testWidgets(
      'deve usar MainAxisSize.min quando expandWidth é false',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            FlatButton(
              text: 'Salvar',
              onPressed: mockOnPressed!.call,
            ),
          ),
        );

        final row = tester.widget<Row>(find.byType(Row));
        expect(row.mainAxisSize, MainAxisSize.min);
      },
    );
  });

  group('Sucesso', () {
    testWidgets(
      'deve chamar onPressed ao ser pressionado',
      (tester) async {
        when(mockOnPressed!.call).thenReturn(null);

        await tester.pumpWidget(
          buildApp(
            FlatButton(
              text: 'Salvar',
              onPressed: mockOnPressed!.call,
            ),
          ),
        );

        await tester.tap(find.text('Salvar'));
        await tester.pumpAndSettle();

        verify(mockOnPressed!.call).called(1);
      },
    );

    testWidgets(
      'deve aplicar cor personalizada ao fundo quando color é fornecida',
      (tester) async {
        const customColor = Colors.green;

        await tester.pumpWidget(
          buildApp(
            FlatButton(
              text: 'Salvar',
              onPressed: mockOnPressed!.call,
              color: customColor,
            ),
          ),
        );

        final elevatedButton = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        final backgroundColor = elevatedButton.style?.backgroundColor?.resolve(
          WidgetState.values.toSet(),
        );
        expect(backgroundColor, customColor);
      },
    );
  });

  group('Erro', () {
    testWidgets(
      'deve desabilitar botão quando onPressed é null',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            const FlatButton(text: 'Salvar'),
          ),
        );

        final elevatedButton = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(elevatedButton.onPressed, isNull);
      },
    );

    testWidgets(
      'deve usar cor padrão do tema quando color não é fornecida',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            FlatButton(
              text: 'Salvar',
              onPressed: mockOnPressed!.call,
            ),
          ),
        );

        final elevatedButton = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        final backgroundColor = elevatedButton.style?.backgroundColor?.resolve(
          WidgetState.values.toSet(),
        );
        expect(
          backgroundColor,
          ThemeManager().lightTheme.appBarTheme.backgroundColor,
        );
      },
    );

    testWidgets(
      'não deve executar onPressed quando botão está desabilitado',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            const FlatButton(text: 'Salvar'),
          ),
        );

        await tester.tap(find.text('Salvar'));
        await tester.pumpAndSettle();

        // Como onPressed é null, o contador não deve mudar
        // (não temos um callback para contar, então só verificamos
        // que o tap não causa erro e o botão permanece desabilitado)
        final elevatedButton = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(elevatedButton.onPressed, isNull);
      },
    );
  });
}
