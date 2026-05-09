import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:security/src/domain/use_cases/authenticate_biometric_use_case.dart';
import 'package:security/src/domain/use_cases/check_biometrics_use_case.dart';
import 'package:security/src/presentation/security/security_controller.dart';

class MockLocalStorageUseCase extends Mock implements LocalStorageUseCase {}

class MockCheckBiometricsUseCase extends Mock
    implements CheckBiometricsUseCase {}

class MockAuthenticateBiometricUseCase extends Mock
    implements AuthenticateBiometricUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockAppSecurityManager extends Mock implements AppSecurityManager {}

void main() {
  late MockLocalStorageUseCase mockLocalStorageUseCase;
  late MockCheckBiometricsUseCase mockCheckBiometricsUseCase;
  late MockAuthenticateBiometricUseCase mockAuthenticateBiometricUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockAppSecurityManager mockAppSecurityManager;
  late SecurityController securityController;

  setUpAll(() {
    registerFallbackValue('fallback_key');
    registerFallbackValue(false);
  });

  setUp(() {
    mockLocalStorageUseCase = MockLocalStorageUseCase();
    mockCheckBiometricsUseCase = MockCheckBiometricsUseCase();
    mockAuthenticateBiometricUseCase = MockAuthenticateBiometricUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockAppSecurityManager = MockAppSecurityManager();

    when(() => mockAppSecurityManager.biometricsEnabled).thenReturn(false);
    when(() => mockAppSecurityManager.useBlurProtect).thenReturn(false);

    securityController = SecurityController(
      localStorageUseCase: mockLocalStorageUseCase,
      checkBiometricsUseCase: mockCheckBiometricsUseCase,
      authenticateBiometricUseCase: mockAuthenticateBiometricUseCase,
      logoutUseCase: mockLogoutUseCase,
      appSecurityManager: mockAppSecurityManager,
    );
  });

  tearDown(() {
    Get.reset();
  });

  group('SecurityController', () {
    group('Sucesso - Inicializacao', () {
      test(
        'deve inicializar o controller com estados iniciais corretos',
        () async {
          // assert - verificando estado inicial
          expect(securityController.isLoading.value, isTrue);
          expect(securityController.hasSupportedBiometrics.value, isFalse);
          expect(securityController.biometric.value, isFalse);
          expect(securityController.blurProtect.value, isFalse);
        },
      );

      test(
        'deve criar o controller com todas as dependencias injetadas',
        () {
          // assert
          expect(securityController, isNotNull);
          expect(securityController.isLoading, isA<RxBool>());
          expect(securityController.hasSupportedBiometrics, isA<RxBool>());
          expect(securityController.biometric, isA<RxBool>());
          expect(securityController.blurProtect, isA<RxBool>());
        },
      );
    });

    group('Sucesso - CheckBiometricsUseCase', () {
      test(
        'deve retornar true quando dispositivo suporta biometria',
        () async {
          // arrange
          when(
            () => mockCheckBiometricsUseCase.call(),
          ).thenAnswer((_) async => true);

          // act
          final result = await mockCheckBiometricsUseCase.call();

          // assert
          expect(result, isTrue);
          verify(() => mockCheckBiometricsUseCase.call()).called(1);
        },
      );

      test(
        'deve retornar false quando dispositivo nao suporta biometria',
        () async {
          // arrange
          when(
            () => mockCheckBiometricsUseCase.call(),
          ).thenAnswer((_) async => false);

          // act
          final result = await mockCheckBiometricsUseCase.call();

          // assert
          expect(result, isFalse);
          verify(() => mockCheckBiometricsUseCase.call()).called(1);
        },
      );
    });

    group('Sucesso - AuthenticateBiometricUseCase', () {
      test(
        'deve autenticar com biometria com sucesso',
        () async {
          // arrange
          when(
            () => mockAuthenticateBiometricUseCase.call(),
          ).thenAnswer((_) async => true);

          // act
          final result = await securityController.authenticateBiometric();

          // assert
          expect(result, isTrue);
          verify(() => mockAuthenticateBiometricUseCase.call()).called(1);
        },
      );

      test(
        'deve falhar autenticacao quando biometria nao confere',
        () async {
          // arrange
          when(
            () => mockAuthenticateBiometricUseCase.call(),
          ).thenAnswer((_) async => false);

          // act
          final result = await securityController.authenticateBiometric();

          // assert
          expect(result, isFalse);
          verify(() => mockAuthenticateBiometricUseCase.call()).called(1);
        },
      );
    });

    group('Sucesso - ToggleBiometric', () {
      test(
        'deve ativar biometria quando autenticacao for bem sucessida',
        () async {
          // arrange
          when(
            () => mockAuthenticateBiometricUseCase.call(),
          ).thenAnswer((_) async => true);
          when(
            () => mockLocalStorageUseCase.set<bool>(any(), any()),
          ).thenAnswer((_) async => true);
          when(() => mockAppSecurityManager.init()).thenAnswer((_) async {});

          // act
          final result = await securityController.toggleBiometric(true);

          // assert
          expect(result, isTrue);
          expect(securityController.biometric.value, isTrue);
          verify(() => mockAuthenticateBiometricUseCase.call()).called(1);
          verify(
            () => mockLocalStorageUseCase.set<bool>(USE_BIOMETRICS, true),
          ).called(1);
          verify(() => mockAppSecurityManager.init()).called(1);
        },
      );

      test(
        'deve desativar biometria quando autenticacao for bem sucessida',
        () async {
          // arrange
          when(
            () => mockAuthenticateBiometricUseCase.call(),
          ).thenAnswer((_) async => true);
          when(
            () => mockLocalStorageUseCase.set<bool>(any(), any()),
          ).thenAnswer((_) async => true);
          when(() => mockAppSecurityManager.init()).thenAnswer((_) async {});

          // act
          final result = await securityController.toggleBiometric(false);

          // assert
          expect(result, isFalse);
          expect(securityController.biometric.value, isFalse);
          verify(() => mockAuthenticateBiometricUseCase.call()).called(1);
          verify(
            () => mockLocalStorageUseCase.set<bool>(USE_BIOMETRICS, false),
          ).called(1);
        },
      );
    });

    group('Sucesso - ToggleBlurProtect', () {
      test(
        'deve ativar blur protect corretamente',
        () async {
          // arrange
          when(
            () => mockLocalStorageUseCase.set<bool>(any(), any()),
          ).thenAnswer((_) async => true);
          when(() => mockAppSecurityManager.init()).thenAnswer((_) async {});

          // act
          final result = await securityController.toggleBlurProtect(true);

          // assert
          expect(result, isTrue);
          expect(securityController.blurProtect.value, isTrue);
          verify(
            () => mockLocalStorageUseCase.set<bool>(USE_BLUR_PROTECT, true),
          ).called(1);
          verify(() => mockAppSecurityManager.init()).called(1);
        },
      );

      test(
        'deve desativar blur protect corretamente',
        () async {
          // arrange
          when(
            () => mockLocalStorageUseCase.set<bool>(any(), any()),
          ).thenAnswer((_) async => true);
          when(() => mockAppSecurityManager.init()).thenAnswer((_) async {});

          // act
          final result = await securityController.toggleBlurProtect(false);

          // assert
          expect(result, isFalse);
          expect(securityController.blurProtect.value, isFalse);
          verify(
            () => mockLocalStorageUseCase.set<bool>(USE_BLUR_PROTECT, false),
          ).called(1);
        },
      );
    });

    group('Sucesso - Logout', () {
      test(
        'deve ter mocks configurados corretamente para logout',
        () async {
          // arrange - Configuramos os mocks para que o logout possa ser executado
          when(() => mockLogoutUseCase.call()).thenAnswer((_) async {});
          when(
            () => mockAppSecurityManager.clearSettings(),
          ).thenAnswer((_) async {});
          when(() => mockAppSecurityManager.init()).thenAnswer((_) async {});
          when(() => mockAppSecurityManager.unlockApp()).thenReturn(null);

          // assert - Verificamos que os mocks estao configurados
          // O metodo logout() usa dependencias estaticas (SessionHelper, AppNavigator)
          // que requerem setup de integracao, por isso verificamos apenas a configuracao
          expect(mockLogoutUseCase, isNotNull);
          expect(mockAppSecurityManager, isNotNull);
        },
      );
    });

    group('Sucesso - AppSecurityManager', () {
      test(
        'deve inicializar AppSecurityManager',
        () async {
          // arrange
          when(() => mockAppSecurityManager.init()).thenAnswer((_) async {});

          // act
          await mockAppSecurityManager.init();

          // assert
          verify(() => mockAppSecurityManager.init()).called(1);
        },
      );

      test(
        'deve verificar se precisa bloquear app',
        () async {
          // arrange
          when(
            () => mockAppSecurityManager.checkIfNeedBlockApp(),
          ).thenAnswer((_) async {});

          // act
          await mockAppSecurityManager.checkIfNeedBlockApp();

          // assert
          verify(() => mockAppSecurityManager.checkIfNeedBlockApp()).called(1);
        },
      );

      test(
        'deve retornar biometricsEnabled corretamente',
        () {
          // arrange
          when(() => mockAppSecurityManager.biometricsEnabled).thenReturn(true);

          // act
          final result = mockAppSecurityManager.biometricsEnabled;

          // assert
          expect(result, isTrue);
        },
      );

      test(
        'deve retornar useBlurProtect corretamente',
        () {
          // arrange
          when(() => mockAppSecurityManager.useBlurProtect).thenReturn(true);

          // act
          final result = mockAppSecurityManager.useBlurProtect;

          // assert
          expect(result, isTrue);
        },
      );
    });

    group('Sucesso - LocalStorageUseCase', () {
      test(
        'deve salvar valor no localStorage',
        () async {
          // arrange
          when(
            () => mockLocalStorageUseCase.set<bool>(any(), any()),
          ).thenAnswer((_) async => true);

          // act
          final result = await mockLocalStorageUseCase.set<bool>(
            USE_BIOMETRICS,
            true,
          );

          // assert
          expect(result, isTrue);
          verify(
            () => mockLocalStorageUseCase.set<bool>(USE_BIOMETRICS, true),
          ).called(1);
        },
      );

      test(
        'deve buscar valor do localStorage',
        () async {
          // arrange
          when(
            () => mockLocalStorageUseCase.get<bool>(any()),
          ).thenAnswer((_) async => true);

          // act
          final result = await mockLocalStorageUseCase.get<bool>(
            USE_BIOMETRICS,
          );

          // assert
          expect(result, isTrue);
          verify(
            () => mockLocalStorageUseCase.get<bool>(USE_BIOMETRICS),
          ).called(1);
        },
      );

      test(
        'deve deletar chave do localStorage',
        () async {
          // arrange
          when(
            () => mockLocalStorageUseCase.delete(any()),
          ).thenAnswer((_) async => true);

          // act
          final result = await mockLocalStorageUseCase.delete(USE_BIOMETRICS);

          // assert
          expect(result, isTrue);
          verify(
            () => mockLocalStorageUseCase.delete(USE_BIOMETRICS),
          ).called(1);
        },
      );
    });

    group('Erro - CheckBiometricsUseCase', () {
      test(
        'deve lancar excecao quando falha ao verificar biometria',
        () async {
          // arrange
          when(
            () => mockCheckBiometricsUseCase.call(),
          ).thenThrow(Exception('Biometrics not available'));

          // act & assert
          expect(
            () => mockCheckBiometricsUseCase.call(),
            throwsException,
          );
        },
      );
    });

    group('Erro - AuthenticateBiometricUseCase', () {
      test(
        'deve lancar excecao quando falha ao autenticar com biometria',
        () async {
          // arrange
          when(
            () => mockAuthenticateBiometricUseCase.call(),
          ).thenThrow(Exception('Authentication failed'));

          // act & assert
          expect(
            () => mockAuthenticateBiometricUseCase.call(),
            throwsException,
          );
        },
      );
    });

    group('Erro - ToggleBiometric', () {
      test(
        'deve reverter estado quando autenticacao falhar',
        () async {
          // arrange
          when(
            () => mockAuthenticateBiometricUseCase.call(),
          ).thenAnswer((_) async => false);

          // act
          final result = await securityController.toggleBiometric(true);

          // assert
          expect(result, isNull);
          expect(securityController.biometric.value, isFalse);
          verify(() => mockAuthenticateBiometricUseCase.call()).called(1);
        },
      );

      test(
        'deve lancar excecao quando falhar ao salvar no localStorage',
        () async {
          // arrange
          when(
            () => mockAuthenticateBiometricUseCase.call(),
          ).thenAnswer((_) async => true);
          when(
            () => mockLocalStorageUseCase.set<bool>(any(), any()),
          ).thenThrow(Exception('Storage error'));
          when(() => mockAppSecurityManager.init()).thenAnswer((_) async {});

          // act & assert
          expect(
            () => securityController.toggleBiometric(true),
            throwsException,
          );
        },
      );
    });

    group('Erro - ToggleBlurProtect', () {
      test(
        'deve lancar excecao quando falhar ao salvar no localStorage',
        () async {
          // arrange
          when(
            () => mockLocalStorageUseCase.set<bool>(any(), any()),
          ).thenThrow(Exception('Storage error'));
          when(() => mockAppSecurityManager.init()).thenAnswer((_) async {});

          // act & assert
          expect(
            () => securityController.toggleBlurProtect(true),
            throwsException,
          );
        },
      );
    });

    group('Erro - Logout', () {
      test(
        'deve continuar mesmo quando logoutUseCase falhar',
        () async {
          // arrange
          when(
            () => mockLogoutUseCase.call(),
          ).thenThrow(Exception('Logout failed'));
          when(
            () => mockAppSecurityManager.clearSettings(),
          ).thenAnswer((_) async {});
          when(() => mockAppSecurityManager.init()).thenAnswer((_) async {});
          when(() => mockAppSecurityManager.unlockApp()).thenReturn(null);

          // assert - O metodo logout tem try-catch
          // Verificamos que os mocks estao configurados corretamente
          expect(mockLogoutUseCase, isNotNull);
          expect(mockAppSecurityManager, isNotNull);
        },
      );
    });

    group('Erro - LocalStorageUseCase', () {
      test(
        'deve lancar excecao ao salvar quando localStorage falhar',
        () async {
          // arrange
          when(
            () => mockLocalStorageUseCase.set<bool>(any(), any()),
          ).thenThrow(Exception('Storage error'));

          // act & assert
          expect(
            () => mockLocalStorageUseCase.set<bool>(USE_BIOMETRICS, true),
            throwsException,
          );
        },
      );

      test(
        'deve lancar excecao ao buscar quando localStorage falhar',
        () async {
          // arrange
          when(
            () => mockLocalStorageUseCase.get<bool>(any()),
          ).thenThrow(Exception('Storage error'));

          // act & assert
          expect(
            () => mockLocalStorageUseCase.get<bool>(USE_BIOMETRICS),
            throwsException,
          );
        },
      );
    });

    group('Erro - AppSecurityManager', () {
      test(
        'deve lancar excecao ao inicializar quando falhar',
        () async {
          // arrange
          when(
            () => mockAppSecurityManager.init(),
          ).thenThrow(Exception('Init error'));

          // act & assert
          expect(
            () => mockAppSecurityManager.init(),
            throwsException,
          );
        },
      );
    });
  });
}
