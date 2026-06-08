import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class MockOnPressed extends Mock {
  void call(bool value);
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
            ToggleButton(
              value: false,
              text: 'Ativar',
              onPressed: mockOnPressed!.call,
            ),
          ),
        );

        expect(find.text('Ativar'), findsOneWidget);
      },
    );

    testWidgets(
      'deve exibir SecondaryButton sem backgroundColor primário quando value é false',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            ToggleButton(
              value: false,
              text: 'Ativar',
              onPressed: mockOnPressed!.call,
            ),
          ),
        );

        final secondaryButton = tester.widget<SecondaryButton>(
          find.byType(SecondaryButton),
        );
        expect(secondaryButton.backgroundColor, isNull);
      },
    );

    testWidgets(
      'deve exibir SecondaryButton com backgroundColor primário quando value é true',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            ToggleButton(
              value: true,
              text: 'Ativar',
              onPressed: mockOnPressed!.call,
            ),
          ),
        );

        final secondaryButton = tester.widget<SecondaryButton>(
          find.byType(SecondaryButton),
        );
        expect(
          secondaryButton.backgroundColor,
          ThemeManager().lightTheme.primaryColor,
        );
      },
    );
  });

  group('Sucesso', () {
    testWidgets(
      'deve chamar onPressed com false ao ser pressionado quando value inicial é false',
      (tester) async {
        when(() => mockOnPressed!.call(any())).thenReturn(null);

        await tester.pumpWidget(
          buildApp(
            ToggleButton(
              value: false,
              text: 'Ativar',
              onPressed: mockOnPressed!.call,
            ),
          ),
        );

        await tester.tap(find.text('Ativar'));
        await tester.pumpAndSettle();

        verify(() => mockOnPressed!.call(false)).called(1);
      },
    );

    testWidgets(
      'deve chamar onPressed com true ao ser pressionado quando value inicial é true',
      (tester) async {
        when(() => mockOnPressed!.call(any())).thenReturn(null);

        await tester.pumpWidget(
          buildApp(
            ToggleButton(
              value: true,
              text: 'Ativar',
              onPressed: mockOnPressed!.call,
            ),
          ),
        );

        await tester.tap(find.text('Ativar'));
        await tester.pumpAndSettle();

        verify(() => mockOnPressed!.call(true)).called(1);
      },
    );

    testWidgets(
      'deve alternar backgroundColor do SecondaryButton ao ser pressionado',
      (tester) async {
        when(() => mockOnPressed!.call(any())).thenReturn(null);

        await tester.pumpWidget(
          buildApp(
            ToggleButton(
              value: false,
              text: 'Ativar',
              onPressed: mockOnPressed!.call,
            ),
          ),
        );

        var secondaryButton = tester.widget<SecondaryButton>(
          find.byType(SecondaryButton),
        );
        expect(secondaryButton.backgroundColor, isNull);

        await tester.tap(find.text('Ativar'));
        await tester.pumpAndSettle();

        secondaryButton = tester.widget<SecondaryButton>(
          find.byType(SecondaryButton),
        );
        expect(
          secondaryButton.backgroundColor,
          ThemeManager().lightTheme.primaryColor,
        );
      },
    );

    testWidgets(
      'deve alternar valor múltiplas vezes corretamente',
      (tester) async {
        when(() => mockOnPressed!.call(any())).thenReturn(null);

        await tester.pumpWidget(
          buildApp(
            ToggleButton(
              value: false,
              text: 'Ativar',
              onPressed: mockOnPressed!.call,
            ),
          ),
        );

        await tester.tap(find.text('Ativar'));
        await tester.pumpAndSettle();
        verify(() => mockOnPressed!.call(false)).called(1);

        await tester.tap(find.text('Ativar'));
        await tester.pumpAndSettle();
        verify(() => mockOnPressed!.call(true)).called(1);

        await tester.tap(find.text('Ativar'));
        await tester.pumpAndSettle();
        verify(() => mockOnPressed!.call(false)).called(1);
      },
    );
  });

  group('Sincronização', () {
    testWidgets(
      'deve atualizar widget.value para true após alternar',
      (tester) async {
        when(() => mockOnPressed!.call(any())).thenReturn(null);

        await tester.pumpWidget(
          buildApp(
            ToggleButton(
              value: false,
              text: 'Ativar',
              onPressed: mockOnPressed!.call,
            ),
          ),
        );

        await tester.tap(find.text('Ativar'));
        await tester.pumpAndSettle();

        final toggleButton = tester.widget<ToggleButton>(
          find.byType(ToggleButton),
        );
        expect(toggleButton.value, true);
      },
    );

    testWidgets(
      'deve atualizar widget.value para false após alternar',
      (tester) async {
        when(() => mockOnPressed!.call(any())).thenReturn(null);

        await tester.pumpWidget(
          buildApp(
            ToggleButton(
              value: true,
              text: 'Ativar',
              onPressed: mockOnPressed!.call,
            ),
          ),
        );

        await tester.tap(find.text('Ativar'));
        await tester.pumpAndSettle();

        final toggleButton = tester.widget<ToggleButton>(
          find.byType(ToggleButton),
        );
        expect(toggleButton.value, false);
      },
    );
  });
}
