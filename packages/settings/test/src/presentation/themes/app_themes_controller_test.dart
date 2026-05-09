import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:settings/src/presentation/themes/app_themes_controller.dart';

class MockThemeController extends Mock implements ThemeController {}

class MockDynamicIconUseCase extends Mock implements DynamicIconUseCase {}

void main() {
  late MockThemeController mockThemeController;
  late MockDynamicIconUseCase mockDynamicIconUseCase;
  late AppThemesController controller;

  setUpAll(() {
    Get.testMode = true;
    registerFallbackValue('default_icon');
  });

  setUp(() {
    mockThemeController = MockThemeController();
    mockDynamicIconUseCase = MockDynamicIconUseCase();

    when(() => mockThemeController.currentThemeData).thenReturn('light');

    controller = AppThemesController(
      themeController: mockThemeController,
      dynamicIconUseCase: mockDynamicIconUseCase,
    );
  });

  tearDown(() {
    Get.reset();
  });

  group('AppThemesController - Propriedades', () {
    test('deve retornar currentThemeData corretamente', () {
      final result = controller.currentThemeData;
      expect(result, 'light');
      verify(() => mockThemeController.currentThemeData).called(1);
    });

    test('deve iniciar com currentAppIcon vazio', () {
      expect(controller.currentAppIcon.value, '');
    });

    test('deve iniciar com supportsAlternateIcons como false', () {
      expect(controller.supportsAlternateIcons.value, false);
    });
  });

  group('AppThemesController - onReady', () {
    test(
      'deve atualizar supportsAlternateIcons quando sucesso',
      () async {
        when(() => mockDynamicIconUseCase.supportsAlternateIcons()).thenAnswer(
          (_) async => const Success<bool>(true),
        );
        when(() => mockDynamicIconUseCase.currentIcon()).thenAnswer(
          (_) async => const Success<String>('icon_default'),
        );

        controller.onReady();

        await Future.delayed(const Duration(milliseconds: 100));

        expect(controller.supportsAlternateIcons.value, true);
      },
    );

    test(
      'deve atualizar currentAppIcon quando sucesso',
      () async {
        when(() => mockDynamicIconUseCase.supportsAlternateIcons()).thenAnswer(
          (_) async => const Success<bool>(false),
        );
        when(() => mockDynamicIconUseCase.currentIcon()).thenAnswer(
          (_) async => const Success<String>('icon_blue'),
        );

        controller.onReady();

        await Future.delayed(const Duration(milliseconds: 100));

        expect(controller.currentAppIcon.value, 'icon_blue');
      },
    );

    test(
      'deve manter supportsAlternateIcons false quando erro',
      () async {
        when(() => mockDynamicIconUseCase.supportsAlternateIcons()).thenAnswer(
          (_) async => Error<bool>(BaseException(message: 'Error')),
        );
        when(() => mockDynamicIconUseCase.currentIcon()).thenAnswer(
          (_) async => const Success<String>('icon_default'),
        );

        controller.onReady();

        await Future.delayed(const Duration(milliseconds: 100));

        expect(controller.supportsAlternateIcons.value, false);
      },
    );

    test(
      'deve manter currentAppIcon vazio quando erro',
      () async {
        when(() => mockDynamicIconUseCase.supportsAlternateIcons()).thenAnswer(
          (_) async => const Success<bool>(true),
        );
        when(() => mockDynamicIconUseCase.currentIcon()).thenAnswer(
          (_) async => Error<String>(BaseException(message: 'Error')),
        );

        controller.onReady();

        await Future.delayed(const Duration(milliseconds: 100));

        expect(controller.currentAppIcon.value, '');
      },
    );

    test(
      'deve atualizar ambos quando sucesso',
      () async {
        when(() => mockDynamicIconUseCase.supportsAlternateIcons()).thenAnswer(
          (_) async => const Success<bool>(true),
        );
        when(() => mockDynamicIconUseCase.currentIcon()).thenAnswer(
          (_) async => const Success<String>('icon_custom'),
        );

        controller.onReady();

        await Future.delayed(const Duration(milliseconds: 100));

        expect(controller.supportsAlternateIcons.value, true);
        expect(controller.currentAppIcon.value, 'icon_custom');
      },
    );
  });

  group('AppThemesController - updateCurrentIcon', () {
    test('deve atualizar currentAppIcon quando sucesso', () async {
      when(() => mockDynamicIconUseCase.currentIcon()).thenAnswer(
        (_) async => const Success<String>('icon_updated'),
      );

      controller.updateCurrentIcon();

      await Future.delayed(const Duration(milliseconds: 100));

      expect(controller.currentAppIcon.value, 'icon_updated');
    });

    test('deve manter currentAppIcon vazio quando erro', () async {
      when(() => mockDynamicIconUseCase.currentIcon()).thenAnswer(
        (_) async => Error<String>(BaseException(message: 'Error')),
      );

      controller.updateCurrentIcon();

      await Future.delayed(const Duration(milliseconds: 100));

      expect(controller.currentAppIcon.value, '');
    });
  });

  group('AppThemesController - onChangeTheme', () {
    test('deve chamar changeTheme com o tema correto', () {
      when(() => mockThemeController.changeTheme(any())).thenAnswer(
        (_) async {},
      );

      controller.onChangeTheme('dark');

      verify(() => mockThemeController.changeTheme('dark')).called(1);
    });

    test('deve chamar changeTheme múltiplas vezes com temas diferentes', () {
      when(() => mockThemeController.changeTheme(any())).thenAnswer(
        (_) async {},
      );

      controller.onChangeTheme('dark');
      controller.onChangeTheme('light');
      controller.onChangeTheme('system');

      verify(() => mockThemeController.changeTheme('dark')).called(1);
      verify(() => mockThemeController.changeTheme('light')).called(1);
      verify(() => mockThemeController.changeTheme('system')).called(1);
    });
  });

  group('AppThemesController - iconsAvailable', () {
    test('deve retornar lista de ícones disponíveis', () {
      final icons = [
        DynamicIcon(
          name: 'default',
          defaultIcon: true,
          path: 'assets/icons/default.png',
        ),
        DynamicIcon(
          name: 'blue',
          defaultIcon: false,
          path: 'assets/icons/blue.png',
        ),
        DynamicIcon(
          name: 'red',
          defaultIcon: false,
          path: 'assets/icons/red.png',
        ),
      ];

      when(() => mockDynamicIconUseCase.iconsAvailable()).thenReturn(icons);

      final result = controller.iconsAvailable();

      expect(result.length, 3);
      expect(result[0].name, 'default');
      expect(result[1].name, 'blue');
      expect(result[2].name, 'red');
      verify(() => mockDynamicIconUseCase.iconsAvailable()).called(1);
    });

    test('deve retornar lista vazia quando não há ícones', () {
      when(() => mockDynamicIconUseCase.iconsAvailable()).thenReturn([]);

      final result = controller.iconsAvailable();

      expect(result, isEmpty);
    });
  });

  group('AppThemesController - setIcon', () {
    test(
      'deve alterar ícone e atualizar currentAppIcon quando sucesso',
      () async {
        when(() => mockDynamicIconUseCase.changeIcon(any())).thenAnswer(
          (_) async => const Success<void>(),
        );
        when(() => mockDynamicIconUseCase.currentIcon()).thenAnswer(
          (_) async => const Success<String>('icon_new'),
        );

        await controller.setIcon('icon_new');

        verify(() => mockDynamicIconUseCase.changeIcon('icon_new')).called(1);
        await Future.delayed(const Duration(milliseconds: 100));
        expect(controller.currentAppIcon.value, 'icon_new');
      },
    );

    test('deve lançar exceção quando changeIcon falha', () async {
      when(() => mockDynamicIconUseCase.changeIcon(any())).thenAnswer(
        (_) async =>
            Error<void>(BaseException(message: 'Failed to change icon')),
      );
      when(() => mockDynamicIconUseCase.currentIcon()).thenAnswer(
        (_) async => const Success<String>('current_icon'),
      );

      final result = await controller.setIcon('invalid_icon');

      expect(result, isA<Error<void>>());
      verify(() => mockDynamicIconUseCase.changeIcon('invalid_icon')).called(1);
    });

    test(
      'deve tentar atualizar currentIcon mesmo quando changeIcon tem erro',
      () async {
        when(() => mockDynamicIconUseCase.changeIcon(any())).thenAnswer(
          (_) async => Error<void>(BaseException(message: 'Error')),
        );
        when(() => mockDynamicIconUseCase.currentIcon()).thenAnswer(
          (_) async => const Success<String>('current_icon'),
        );

        await controller.setIcon('icon_test');

        await Future.delayed(const Duration(milliseconds: 100));
        verify(() => mockDynamicIconUseCase.currentIcon()).called(1);
      },
    );
  });

  group('AppThemesController - onClose', () {
    test('deve executar sem erros ao fechar', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
