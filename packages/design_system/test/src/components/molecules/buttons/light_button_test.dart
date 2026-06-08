// ignore_for_file: deprecated_member_use

import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class MockOnPressed extends Mock {
  void call();
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
            LightButton(
              text: 'Cancelar',
              onPressed: mockOnPressed!.call,
            ),
          ),
        );

        expect(find.text('Cancelar'), findsOneWidget);
      },
    );

    testWidgets(
      'deve usar fundo transparente',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            LightButton(
              text: 'Cancelar',
              onPressed: mockOnPressed!.call,
            ),
          ),
        );

        final textButton = tester.widget<TextButton>(
          find.byType(TextButton),
        );
        final backgroundColor = textButton.style?.backgroundColor?.resolve(
          WidgetState.values.toSet(),
        );
        expect(backgroundColor, AppColors.transparent);
      },
    );

    testWidgets(
      'deve usar AppTextStyle.button como estilo padrão de texto',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            LightButton(
              text: 'Cancelar',
              onPressed: mockOnPressed!.call,
            ),
          ),
        );

        final textWidget = tester.widget<TextWidget>(
          find.byType(TextWidget),
        );
        expect(textWidget.style, isA<AppTextStyle>());
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
            LightButton(
              text: 'Cancelar',
              onPressed: mockOnPressed!.call,
            ),
          ),
        );

        await tester.tap(find.text('Cancelar'));
        await tester.pumpAndSettle();

        verify(mockOnPressed!.call).called(1);
      },
    );

    testWidgets(
      'deve aplicar textStyle personalizado quando fornecido',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            Builder(
              builder: (context) {
                const customColor = Colors.red;
                final customStyle = AppTextStyle.button(
                  context,
                  color: customColor,
                  fontSize: TextSize.font_18,
                );
                return LightButton(
                  text: 'Cancelar',
                  textStyle: customStyle,
                  onPressed: mockOnPressed!.call,
                );
              },
            ),
          ),
        );

        final textWidget = tester.widget<TextWidget>(
          find.byType(TextWidget),
        );
        expect(textWidget.style?.color, Colors.red);
      },
    );

    testWidgets(
      'deve exibir texto com opacidade total quando habilitado',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            LightButton(
              text: 'Cancelar',
              onPressed: mockOnPressed!.call,
            ),
          ),
        );

        final textWidget = tester.widget<TextWidget>(
          find.byType(TextWidget),
        );
        expect(textWidget.style?.color?.alpha, 255);
      },
    );
  });

  group('Erro', () {
    testWidgets(
      'deve desabilitar botão quando onPressed é null',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            const LightButton(text: 'Cancelar'),
          ),
        );

        final textButton = tester.widget<TextButton>(
          find.byType(TextButton),
        );
        expect(textButton.onPressed, isNull);
      },
    );

    testWidgets(
      'deve exibir texto com 50% de opacidade quando desabilitado',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            const LightButton(text: 'Cancelar'),
          ),
        );

        final textWidget = tester.widget<TextWidget>(
          find.byType(TextWidget),
        );
        expect(textWidget.style?.color?.alpha, 127);
      },
    );

    testWidgets(
      'não deve executar ação quando desabilitado',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            const LightButton(text: 'Cancelar'),
          ),
        );

        final textButton = tester.widget<TextButton>(
          find.byType(TextButton),
        );
        expect(textButton.onPressed, isNull);

        await tester.tap(find.text('Cancelar'));
        await tester.pumpAndSettle();

        expect(textButton.onPressed, isNull);
      },
    );
  });
}
