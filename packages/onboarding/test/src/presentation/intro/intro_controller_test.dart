import 'package:clean_code_domain/clean_code_domain.dart';
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

class FakePermission extends Fake implements Permission {}

void main() {
  late MockRequestPermissionUseCase mockRequestPermissionUseCase;
  late MockLocalStorageUseCase mockLocalStorageUseCase;
  late MockGetAppInfoUseCase mockGetAppInfoUseCase;
  late IntroController introController;
  late AppEnvironmentEntity appEnv;

  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
    AppBinding.testMode(true);
    registerFallbackValue(FakeAppEnvironmentEntity());
    registerFallbackValue(FakeAppInfoEntity());
    registerFallbackValue(FakePermission());
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

    introController = IntroController(
      appEnv: appEnv,
      requestPermissionUseCase: mockRequestPermissionUseCase,
      localStorageUseCase: mockLocalStorageUseCase,
      getAppInfoUseCase: mockGetAppInfoUseCase,
    );
  });

  tearDown(() {
    introController.onClose();
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

      test('deve remover appTrackingTransparency quando nao e iOS', () {
        final permissions = introController.permissions;
        expect(permissions.contains('appTrackingTransparency'), isFalse);
      });

      test('deve definir currentPermission corretamente', () {
        introController.setPermission(Permission.location);
        expect(introController.currentPermission, Permission.location);
      });

      test('deve fazer request de notification quando setado', () async {
        introController.setPermission(Permission.notification);

        when(
          () => mockRequestPermissionUseCase.call(Permission.notification),
        ).thenAnswer((_) async => PermissionStatus.granted);

        await introController.requestCurrentPermission();

        verify(
          () => mockRequestPermissionUseCase.call(Permission.notification),
        ).called(1);
      });

      test('deve fazer request de location quando setado', () async {
        introController.setPermission(Permission.location);

        when(
          () => mockRequestPermissionUseCase.call(Permission.location),
        ).thenAnswer((_) async => PermissionStatus.granted);

        await introController.requestCurrentPermission();

        verify(
          () => mockRequestPermissionUseCase.call(Permission.location),
        ).called(1);
      });

      test(
        'deve fazer request de appTrackingTransparency quando setado',
        () async {
          introController.setPermission(Permission.appTrackingTransparency);

          when(
            () => mockRequestPermissionUseCase.call(
              Permission.appTrackingTransparency,
            ),
          ).thenAnswer((_) async => PermissionStatus.granted);

          await introController.requestCurrentPermission();

          verify(
            () => mockRequestPermissionUseCase.call(
              Permission.appTrackingTransparency,
            ),
          ).called(1);
        },
      );

      test(
        'deve retornar isLastPage como true quando indexPage equals permissions length',
        () {
          introController.indexPage.value = 2;
          expect(introController.isLastPage.value, isTrue);
        },
      );

      test(
        'deve retornar isLastPage como false quando nao na ultima pagina',
        () {
          introController.indexPage.value = 0;
          expect(introController.isLastPage.value, isFalse);
        },
      );

      test('deve retornar indexPage inicial como 0', () {
        expect(introController.indexPage.value, 0);
      });

      test('deve retornar currentPermission como null inicial', () {
        expect(introController.currentPermission, isNull);
      });

      test('deve retornar permissionStatus.granted via useCase', () async {
        when(
          () => mockRequestPermissionUseCase.call(Permission.notification),
        ).thenAnswer((_) async => PermissionStatus.granted);

        final result = await mockRequestPermissionUseCase.call(
          Permission.notification,
        );

        expect(result, PermissionStatus.granted);
      });

      test('deve retornar permissionStatus.denied via useCase', () async {
        when(
          () => mockRequestPermissionUseCase.call(Permission.location),
        ).thenAnswer((_) async => PermissionStatus.denied);

        final result = await mockRequestPermissionUseCase.call(
          Permission.location,
        );

        expect(result, PermissionStatus.denied);
      });

      test('deve continuar normalmente quando permission e null', () async {
        when(
          () => mockRequestPermissionUseCase.call(any()),
        ).thenAnswer((_) async => PermissionStatus.granted);

        await introController.requestCurrentPermission();

        verifyNever(
          () => mockRequestPermissionUseCase.call(any()),
        );
      });

      test('deve nao fazer nada quando isLastPage e false', () async {
        introController.indexPage.value = 0;
        introController.setPermission(Permission.location);

        when(
          () => mockRequestPermissionUseCase.call(any()),
        ).thenAnswer((_) async => PermissionStatus.granted);

        await introController.requestCurrentPermission();

        verifyNever(
          () => mockLocalStorageUseCase.set<bool>(INTRO_DONE, true),
        );
      });
    });

    group('Erro', () {
      test(
        'deve lancar excecao quando requestPermissionUseCase falhar',
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
    });
  });
}
