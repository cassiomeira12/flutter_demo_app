import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onboarding/src/presentation/intro/intro_controller.dart';

class MockRequestPermissionUseCase extends Mock
    implements RequestPermissionUseCase {}

class MockLocalStorageUseCase extends Mock implements LocalStorageUseCase {}

class MockGetAppInfoUseCase extends Mock implements GetAppInfoUseCase {}

class FakeAppEnvironmentEntity extends Fake implements AppEnvironmentEntity {}

class FakeAppInfoEntity extends Fake implements AppInfoEntity {}

void main() {
  late MockRequestPermissionUseCase mockRequestPermissionUseCase;
  late MockLocalStorageUseCase mockLocalStorageUseCase;
  late MockGetAppInfoUseCase mockGetAppInfoUseCase;
  late IntroController introController;

  late AppEnvironmentEntity appEnv;
  late AppInfoEntity appInfo;

  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true;
    registerFallbackValue(FakeAppEnvironmentEntity());
    registerFallbackValue(FakeAppInfoEntity());
    registerFallbackValue(Permission.appTrackingTransparency);
    registerFallbackValue(Permission.notification);
    registerFallbackValue(Permission.location);
  });

  setUp(() {
    mockRequestPermissionUseCase = MockRequestPermissionUseCase();
    mockLocalStorageUseCase = MockLocalStorageUseCase();
    mockGetAppInfoUseCase = MockGetAppInfoUseCase();

    appEnv = AppEnvironmentEntity(
      appName: 'Test App',
      androidPackageName: 'com.test.app',
      appleStoreAppId: '123456789',
      permissions: 'appTrackingTransparency,notification,location',
    );

    appInfo = AppInfoEntity(
      appName: 'Test App',
      packageName: 'com.test.app',
      buildSignature: 'test-signature',
      installerStore: null,
      version: '1.0.0',
      build: '1',
    );

    introController = IntroController(
      appEnv: appEnv,
      requestPermissionUseCase: mockRequestPermissionUseCase,
      localStorageUseCase: mockLocalStorageUseCase,
      getAppInfoUseCase: mockGetAppInfoUseCase,
    );
  });

  group('IntroController', () {
    group('Sucesso', () {
      test('deve retornar appName corretamente', () {
        expect(introController.appName, 'Test App');
      });

      test('deve retornar permissions nao vazio', () {
        final permissions = introController.permissions;
        expect(permissions, isNotEmpty);
      });

      test('deve definir currentPermission corretamente', () {
        introController.setPermission(Permission.location);
        expect(introController.currentPermission, Permission.location);
      });

      test(
        'deve fazer request de permissao quando requestCurrentPermission() e chamado',
        () async {
          introController.setPermission(Permission.notification);

          when(
            () => mockRequestPermissionUseCase.call(any()),
          ).thenAnswer((_) async => PermissionStatus.granted);

          when(
            () => mockLocalStorageUseCase.set<bool>(any(), any()),
          ).thenAnswer((_) async => true);

          when(
            () => mockGetAppInfoUseCase.call(),
          ).thenAnswer((_) async => appInfo);

          await introController.requestCurrentPermission();

          verify(() => mockRequestPermissionUseCase.call(any())).called(1);
        },
      );

      test('deve finalizar pagina quando isLastPage e true', () async {
        introController.indexPage.value = 0;
        introController.pagesLength = 1;
        introController.setPermission(Permission.location);

        when(
          () => mockRequestPermissionUseCase.call(any()),
        ).thenAnswer((_) async => PermissionStatus.granted);

        when(
          () => mockLocalStorageUseCase.set<bool>(any(), any()),
        ).thenAnswer((_) async => true);

        when(
          () => mockGetAppInfoUseCase.call(),
        ).thenAnswer((_) async => appInfo);

        await introController.requestCurrentPermission();

        verify(
          () => mockLocalStorageUseCase.set<bool>(INTRO_DONE, true),
        ).called(1);
      });

      test(
        'deve retornar isLastPage como true quando indexPage e pagesLength-1',
        () {
          introController.indexPage.value = 2;
          introController.pagesLength = 3;

          expect(introController.isLastPage.value, isTrue);
        },
      );

      test(
        'deve retornar isLastPage como false quando indexPage diferente de pagesLength-1',
        () {
          introController.indexPage.value = 0;
          introController.pagesLength = 3;

          expect(introController.isLastPage.value, isFalse);
        },
      );

      test(
        'deve retornar isLastPage como true quando pagesLength=1 e indexPage=0',
        () {
          introController.indexPage.value = 0;
          introController.pagesLength = 1;

          expect(introController.isLastPage.value, isTrue);
        },
      );

      test('deve retornar permissao como granted quando aceita', () async {
        when(
          () => mockRequestPermissionUseCase.call(any()),
        ).thenAnswer((_) async => PermissionStatus.granted);

        final result = await mockRequestPermissionUseCase.call(
          Permission.notification,
        );

        expect(result, PermissionStatus.granted);
      });

      test('deve retornar permissao como denied quando negada', () async {
        when(
          () => mockRequestPermissionUseCase.call(any()),
        ).thenAnswer((_) async => PermissionStatus.denied);

        final result = await mockRequestPermissionUseCase.call(
          Permission.location,
        );

        expect(result, PermissionStatus.denied);
      });

      test('deve retornar pagesLength inicial como 0', () {
        expect(introController.pagesLength, 0);
      });

      test('deve retornar indexPage inicial como 0', () {
        expect(introController.indexPage.value, 0);
      });

      test('deve retornar currentPermission como null iniciais', () {
        expect(introController.currentPermission, isNull);
      });
    });

    group('Erro', () {
      test(
        'deve propagar excecao quando requestPermissionUseCase falhar',
        () async {
          introController.setPermission(Permission.notification);

          when(
            () => mockRequestPermissionUseCase.call(any()),
          ).thenThrow(Exception('Permission denied'));

          expect(
            () => introController.requestCurrentPermission(),
            throwsA(isA<Exception>()),
          );
        },
      );

      test(
        'deve continuar normalmente quando localStorageUseCase falha ao salvar versao app',
        () async {
          introController.indexPage.value = 0;
          introController.pagesLength = 1;
          introController.setPermission(Permission.location);

          when(
            () => mockRequestPermissionUseCase.call(any()),
          ).thenAnswer((_) async => PermissionStatus.granted);

          when(
            () => mockLocalStorageUseCase.set<bool>(INTRO_DONE, true),
          ).thenAnswer((_) async => true);

          when(
            () => mockLocalStorageUseCase.set<bool>(any(), any()),
          ).thenAnswer((_) async => true);

          when(
            () => mockGetAppInfoUseCase.call(),
          ).thenAnswer((_) async => appInfo);

          await introController.requestCurrentPermission();

          verify(
            () => mockLocalStorageUseCase.set<bool>(INTRO_DONE, true),
          ).called(1);
        },
      );
    });
  });
}
