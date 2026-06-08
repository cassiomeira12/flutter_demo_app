import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class MockCallbacks extends Mock {
  Future<void> onPressed();
  Future<bool> onValidation();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockCallbacks mockCallbacks;

  setUpAll(() {
    AppBinding.testMode(true);
    ThemeManager().defineColor(
      lightColorScheme: LightColorScheme(color: Colors.blue),
      darkColorScheme: DarkColorScheme(color: Colors.blue),
    );
  });

  setUp(() {
    mockCallbacks = MockCallbacks();
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
            FutureButton(
              text: 'Salvar',
              onPressed: () => mockCallbacks.onPressed(),
            ),
          ),
        );

        expect(find.text('Salvar'), findsOneWidget);
      },
    );

    testWidgets(
      'deve expandir largura quando expandWidth é true',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            FutureButton(
              text: 'Salvar',
              onPressed: () => mockCallbacks.onPressed(),
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
            FutureButton(
              text: 'Salvar',
              onPressed: () => mockCallbacks.onPressed(),
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
        when(() => mockCallbacks.onPressed()).thenAnswer((_) async {});

        await tester.pumpWidget(
          buildApp(
            FutureButton(
              text: 'Salvar',
              onPressed: () => mockCallbacks.onPressed(),
            ),
          ),
        );

        await tester.tap(find.text('Salvar'));
        await tester.pumpAndSettle();

        verify(() => mockCallbacks.onPressed()).called(1);
      },
    );

    testWidgets(
      'deve exibir loading enquando onPressed é executado',
      (tester) async {
        final completer = Completer<void>();
        when(() => mockCallbacks.onPressed()).thenAnswer(
          (_) => completer.future,
        );

        await tester.pumpWidget(
          buildApp(
            FutureButton(
              text: 'Salvar',
              onPressed: () => mockCallbacks.onPressed(),
            ),
          ),
        );

        await tester.tap(find.text('Salvar'));
        await tester.pump();

        expect(find.byType(CircularLoadingWidget), findsOneWidget);

        completer.complete();
        await tester.pumpAndSettle();

        expect(find.byType(CircularLoadingWidget), findsNothing);
      },
    );

    testWidgets(
      'deve remover loading após onPressed ser concluído',
      (tester) async {
        when(() => mockCallbacks.onPressed()).thenAnswer((_) async {});

        await tester.pumpWidget(
          buildApp(
            FutureButton(
              text: 'Salvar',
              onPressed: () => mockCallbacks.onPressed(),
            ),
          ),
        );

        await tester.tap(find.text('Salvar'));
        await tester.pumpAndSettle();

        expect(find.byType(CircularLoadingWidget), findsNothing);
      },
    );

    testWidgets(
      'deve chamar onPressed quando onValidation retorna true',
      (tester) async {
        when(() => mockCallbacks.onPressed()).thenAnswer((_) async {});
        when(() => mockCallbacks.onValidation()).thenAnswer((_) async => true);

        await tester.pumpWidget(
          buildApp(
            FutureButton(
              text: 'Salvar',
              onPressed: () => mockCallbacks.onPressed(),
              onValidation: () => mockCallbacks.onValidation(),
            ),
          ),
        );

        await tester.tap(find.text('Salvar'));
        await tester.pumpAndSettle();

        verify(() => mockCallbacks.onValidation()).called(1);
        verify(() => mockCallbacks.onPressed()).called(1);
      },
    );
  });

  group('Erro', () {
    testWidgets(
      'deve desabilitar botão quando onPressed é null',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            const FutureButton(
              text: 'Salvar',
              onPressed: null,
            ),
          ),
        );

        final textButton = tester.widget<TextButton>(find.byType(TextButton));
        expect(textButton.onPressed, isNull);
      },
    );

    testWidgets(
      'deve impedir chamada de onPressed quando validação falha',
      (tester) async {
        when(() => mockCallbacks.onValidation()).thenAnswer((_) async => false);

        await tester.pumpWidget(
          buildApp(
            FutureButton(
              text: 'Salvar',
              onPressed: () => mockCallbacks.onPressed(),
              onValidation: () => mockCallbacks.onValidation(),
            ),
          ),
        );

        await tester.tap(find.text('Salvar'));
        await tester.pumpAndSettle();

        verify(() => mockCallbacks.onValidation()).called(1);
        verifyNever(() => mockCallbacks.onPressed());
      },
    );

    testWidgets(
      'deve resetar loading quando onPressed lança exceção',
      (tester) async {
        final errors = <Object>[];

        when(() => mockCallbacks.onPressed()).thenAnswer(
          (_) => Future<void>.error(Exception('Erro')),
        );

        await tester.pumpWidget(
          buildApp(
            FutureButton(
              text: 'Salvar',
              onPressed: () => mockCallbacks.onPressed(),
            ),
          ),
        );

        await runZonedGuarded(
          () async {
            await tester.tap(find.text('Salvar'));
            await tester.pump();
          },
          (error, stack) {
            errors.add(error);
          },
        );

        expect(errors, hasLength(1));
        expect(find.byType(CircularLoadingWidget), findsNothing);
      },
    );
  });
}
