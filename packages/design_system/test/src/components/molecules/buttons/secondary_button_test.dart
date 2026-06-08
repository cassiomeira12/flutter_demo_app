// ignore_for_file: deprecated_member_use

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
    return const Icon(Icons.arrow_back, key: Key('mock_icon_secondary'));
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
            SecondaryButton(
              text: 'Voltar',
              onPressed: mockOnPressed!.call,
            ),
          ),
        );

        expect(find.text('Voltar'), findsOneWidget);
      },
    );

    testWidgets(
      'deve renderizar ícone quando fornecido',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            SecondaryButton(
              text: 'Voltar',
              icon: const MockIconWidget(),
              onPressed: mockOnPressed!.call,
            ),
          ),
        );

        expect(find.byKey(const Key('mock_icon_secondary')), findsOneWidget);
      },
    );

    testWidgets(
      'deve renderizar sem texto quando text é null',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            const SecondaryButton(),
          ),
        );

        final textWidget = tester.widget<TextWidget>(
          find.byType(TextWidget),
        );
        expect(textWidget.text, isEmpty);
      },
    );

    testWidgets(
      'deve expandir largura quando expandWidth é true',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            SecondaryButton(
              text: 'Voltar',
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
            SecondaryButton(
              text: 'Voltar',
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
            SecondaryButton(
              text: 'Voltar',
              onPressed: mockOnPressed!.call,
            ),
          ),
        );

        await tester.tap(find.text('Voltar'));
        await tester.pumpAndSettle();

        verify(mockOnPressed!.call).called(1);
      },
    );

    testWidgets(
      'deve usar backgroundColor do tema (highlightColor) por padrão',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            SecondaryButton(
              text: 'Voltar',
              onPressed: mockOnPressed!.call,
            ),
          ),
        );

        final textButton = tester.widget<TextButton>(
          find.byType(TextButton),
        );
        final resolvedColor = textButton.style?.backgroundColor?.resolve(
          WidgetState.values.toSet(),
        );
        expect(resolvedColor, ThemeManager().lightTheme.highlightColor);
      },
    );

    testWidgets(
      'deve aplicar backgroundColor personalizado quando fornecido',
      (tester) async {
        const customColor = Colors.orange;

        await tester.pumpWidget(
          buildApp(
            SecondaryButton(
              text: 'Voltar',
              onPressed: mockOnPressed!.call,
              backgroundColor: customColor,
            ),
          ),
        );

        final textButton = tester.widget<TextButton>(
          find.byType(TextButton),
        );
        final resolvedColor = textButton.style?.backgroundColor?.resolve(
          WidgetState.values.toSet(),
        );
        expect(resolvedColor, customColor);
      },
    );

    testWidgets(
      'deve aplicar textColor personalizado quando fornecido',
      (tester) async {
        const customColor = Colors.teal;

        await tester.pumpWidget(
          buildApp(
            SecondaryButton(
              text: 'Voltar',
              onPressed: mockOnPressed!.call,
              textColor: customColor,
            ),
          ),
        );

        final textWidget = tester.widget<TextWidget>(
          find.byType(TextWidget),
        );
        expect(textWidget.style?.color, customColor);
      },
    );
  });

  group('Erro', () {
    testWidgets(
      'deve desabilitar botão quando onPressed é null',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            const SecondaryButton(text: 'Voltar'),
          ),
        );

        final textButton = tester.widget<TextButton>(
          find.byType(TextButton),
        );
        expect(textButton.onPressed, isNull);
      },
    );

    testWidgets(
      'deve aplicar 50%% de opacidade no fundo quando desabilitado',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            const SecondaryButton(text: 'Voltar'),
          ),
        );

        final textButton = tester.widget<TextButton>(
          find.byType(TextButton),
        );
        final resolvedColor = textButton.style?.backgroundColor?.resolve(
          WidgetState.values.toSet(),
        );
        expect(resolvedColor?.alpha, 127);
      },
    );

    testWidgets(
      'deve ocultar borda quando desabilitado',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            const SecondaryButton(text: 'Voltar'),
          ),
        );

        final textButton = tester.widget<TextButton>(
          find.byType(TextButton),
        );
        final shape = textButton.style?.shape?.resolve(
          WidgetState.values.toSet(),
        );
        expect(shape, isA<RoundedRectangleBorder>());

        final roundedRect = shape! as RoundedRectangleBorder;
        expect(roundedRect.side.style, BorderStyle.none);
      },
    );

    testWidgets(
      'deve exibir borda sólida quando habilitado',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            SecondaryButton(
              text: 'Voltar',
              onPressed: mockOnPressed!.call,
            ),
          ),
        );

        final textButton = tester.widget<TextButton>(
          find.byType(TextButton),
        );
        final shape = textButton.style?.shape?.resolve(
          WidgetState.values.toSet(),
        );
        expect(shape, isA<RoundedRectangleBorder>());

        final roundedRect = shape! as RoundedRectangleBorder;
        expect(roundedRect.side.style, BorderStyle.solid);
      },
    );
  });
}
