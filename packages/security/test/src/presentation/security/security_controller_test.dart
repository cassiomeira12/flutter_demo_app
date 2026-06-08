import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:security/src/domain/domain.dart';
import 'package:security/src/presentation/security/security_controller.dart';

class MockLocalStorageUseCase extends Mock implements LocalStorageUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockAppSecurityManager extends Mock implements AppSecurityManager {}

class MockLocalAuthService extends Mock implements LocalAuthService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockLocalStorageUseCase mockLocalStorageUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockAppSecurityManager mockAppSecurityManager;
  late MockLocalAuthService mockLocalAuthService;
  late CheckBiometricsUseCase checkBiometricsUseCase;
  late AuthenticateBiometricUseCase authenticateBiometricUseCase;
  late SecurityController securityController;

  setUpAll(() {
    AppBinding.testMode(true);
    registerFallbackValue('fallback_key');
    registerFallbackValue(false);
  });

  setUp(() {
    mockLocalStorageUseCase = MockLocalStorageUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockAppSecurityManager = MockAppSecurityManager();
    mockLocalAuthService = MockLocalAuthService();

    checkBiometricsUseCase = CheckBiometricsUseCase(
      localAuthService: mockLocalAuthService,
    );

    authenticateBiometricUseCase = AuthenticateBiometricUseCase(
      localAuthService: mockLocalAuthService,
    );

    when(() => mockAppSecurityManager.biometricsEnabled).thenReturn(false);
    when(() => mockAppSecurityManager.useBlurProtect).thenReturn(false);

    securityController = SecurityController(
      localStorageUseCase: mockLocalStorageUseCase,
      checkBiometricsUseCase: checkBiometricsUseCase,
      authenticateBiometricUseCase: authenticateBiometricUseCase,
      logoutUseCase: mockLogoutUseCase,
      appSecurityManager: mockAppSecurityManager,
    );
  });

  tearDown(() {
    AppBinding.reset();
  });

  group('SecurityController', () {
    group('Sucesso - Inicializacao', () {
      test(
        'deve inicializar o controller com estados bool corretos',
        () {
          expect(securityController.isLoading.value, isTrue);
          expect(securityController.hasSupportedBiometrics.value, isFalse);
          expect(securityController.biometric.value, isFalse);
          expect(securityController.blurProtect.value, isFalse);
        },
      );
    });

    group('Sucesso - AuthenticateBiometric', () {
      test(
        'deve retornar true quando autenticacao biometrica for bem sucedida',
        () async {
          when(
            () => mockLocalAuthService.authenticate(),
          ).thenAnswer((_) async => true);

          final result = await securityController.authenticateBiometric();

          expect(result, isTrue);
          verify(() => mockLocalAuthService.authenticate()).called(1);
        },
      );

      test(
        'deve retornar false quando autenticacao biometrica falhar',
        () async {
          when(
            () => mockLocalAuthService.authenticate(),
          ).thenAnswer((_) async => false);

          final result = await securityController.authenticateBiometric();

          expect(result, isFalse);
          verify(() => mockLocalAuthService.authenticate()).called(1);
        },
      );
    });

    group('Sucesso - ToggleBiometric', () {
      test(
        'deve ativar biometria quando toggleBiometric(true) e autenticacao '
        'for bem sucedida',
        () async {
          when(
            () => mockLocalAuthService.authenticate(),
          ).thenAnswer((_) async => true);
          when(
            () => mockLocalStorageUseCase.set<bool>(any(), any()),
          ).thenAnswer((_) async => true);
          when(() => mockAppSecurityManager.init()).thenAnswer((_) async {});

          final result = await securityController.toggleBiometric(true);

          expect(result, isTrue);
          expect(securityController.biometric.value, isTrue);
          verify(() => mockLocalAuthService.authenticate()).called(1);
          verify(
            () => mockLocalStorageUseCase.set<bool>(USE_BIOMETRICS, true),
          ).called(1);
          verify(() => mockAppSecurityManager.init()).called(1);
        },
      );

      test(
        'deve desativar biometria quando toggleBiometric(false) e autenticacao '
        'for bem sucedida',
        () async {
          when(
            () => mockLocalAuthService.authenticate(),
          ).thenAnswer((_) async => true);
          when(
            () => mockLocalStorageUseCase.set<bool>(any(), any()),
          ).thenAnswer((_) async => true);
          when(() => mockAppSecurityManager.init()).thenAnswer((_) async {});

          final result = await securityController.toggleBiometric(false);

          expect(result, isFalse);
          expect(securityController.biometric.value, isFalse);
          verify(() => mockLocalAuthService.authenticate()).called(1);
          verify(
            () => mockLocalStorageUseCase.set<bool>(USE_BIOMETRICS, false),
          ).called(1);
          verify(() => mockAppSecurityManager.init()).called(1);
        },
      );
    });

    group('Sucesso - ToggleBlurProtect', () {
      test(
        'deve ativar blur protect quando toggleBlurProtect(true)',
        () async {
          when(
            () => mockLocalStorageUseCase.set<bool>(any(), any()),
          ).thenAnswer((_) async => true);
          when(() => mockAppSecurityManager.init()).thenAnswer((_) async {});

          final result = await securityController.toggleBlurProtect(true);

          expect(result, isTrue);
          expect(securityController.blurProtect.value, isTrue);
          verify(
            () => mockLocalStorageUseCase.set<bool>(USE_BLUR_PROTECT, true),
          ).called(1);
          verify(() => mockAppSecurityManager.init()).called(1);
        },
      );

      test(
        'deve desativar blur protect quando toggleBlurProtect(false)',
        () async {
          when(
            () => mockLocalStorageUseCase.set<bool>(any(), any()),
          ).thenAnswer((_) async => true);
          when(() => mockAppSecurityManager.init()).thenAnswer((_) async {});

          final result = await securityController.toggleBlurProtect(false);

          expect(result, isFalse);
          expect(securityController.blurProtect.value, isFalse);
          verify(
            () => mockLocalStorageUseCase.set<bool>(USE_BLUR_PROTECT, false),
          ).called(1);
        },
      );
    });

    group('Erro - Autenticacao Biometrica Falha', () {
      test(
        'deve reverter estado biometrico quando authenticateBiometric '
        'retornar false no toggleBiometric',
        () async {
          when(
            () => mockLocalAuthService.authenticate(),
          ).thenAnswer((_) async => false);

          final result = await securityController.toggleBiometric(true);

          expect(result, isNull);
          expect(securityController.biometric.value, isFalse);
          verify(() => mockLocalAuthService.authenticate()).called(1);
        },
      );
    });

    group('Erro - LocalStorageUseCase', () {
      test(
        'deve lancar excecao quando localStorage falhar ao salvar '
        'no toggleBiometric',
        () async {
          when(
            () => mockLocalAuthService.authenticate(),
          ).thenAnswer((_) async => true);
          when(
            () => mockLocalStorageUseCase.set<bool>(any(), any()),
          ).thenThrow(Exception('Storage error'));

          expect(
            () => securityController.toggleBiometric(true),
            throwsException,
          );
        },
      );

      test(
        'deve lancar excecao quando localStorage falhar ao salvar '
        'no toggleBlurProtect',
        () async {
          when(
            () => mockLocalStorageUseCase.set<bool>(any(), any()),
          ).thenThrow(Exception('Storage error'));

          expect(
            () => securityController.toggleBlurProtect(true),
            throwsException,
          );
        },
      );
    });

    group('Erro - AuthenticateBiometricUseCase', () {
      test(
        'deve propagar excecao lancada pelo LocalAuthService',
        () async {
          when(
            () => mockLocalAuthService.authenticate(),
          ).thenThrow(Exception('Biometric error'));

          expect(
            () => securityController.authenticateBiometric(),
            throwsException,
          );
        },
      );
    });

    group('Sucesso - OnReady', () {
      test(
        'deve atualizar biometric e blurProtect do AppSecurityManager '
        'no onReady',
        () {
          when(
            () => mockLocalAuthService.isDeviceSupported(),
          ).thenAnswer((_) async => true);
          when(
            () => mockAppSecurityManager.biometricsEnabled,
          ).thenReturn(true);
          when(() => mockAppSecurityManager.useBlurProtect).thenReturn(true);

          securityController.onReady();

          expect(securityController.biometric.value, isTrue);
          expect(securityController.blurProtect.value, isTrue);
        },
      );

      test(
        'deve verificar suporte a biometria e atualizar isLoading '
        'apos onReady',
        () async {
          when(
            () => mockLocalAuthService.isDeviceSupported(),
          ).thenAnswer((_) async => true);

          securityController.onReady();

          // Aguarda microtasks para processar o resultado assincrono
          // de _checkDeviceSupportedBiometrics
          await Future.delayed(Duration.zero);

          expect(securityController.hasSupportedBiometrics.value, isTrue);
          expect(securityController.isLoading.value, isFalse);
          verify(() => mockLocalAuthService.isDeviceSupported()).called(1);
        },
      );
    });

    group('Sucesso - OnClose', () {
      test(
        'deve fechar os RxBools sem lancar excecao',
        () {
          expect(
            () => securityController.onClose(),
            returnsNormally,
          );
        },
      );
    });

    group('Sucesso - OnAppForeground', () {
      test(
        'deve chamar onAppForeground sem lancar excecao',
        () {
          expect(
            () => securityController.onAppForeground(),
            returnsNormally,
          );
        },
      );
    });

    group('Sucesso - UnlockApp', () {
      test(
        'deve retornar rapidamente quando nao estiver na tela '
        'de security blocked',
        () async {
          when(
            () => mockLocalAuthService.authenticate(),
          ).thenAnswer((_) async => true);

          await securityController.unlockApp();

          verifyNever(() => mockLocalAuthService.authenticate());
        },
      );
    });
  });
}
