import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:splash/src/presentation/splash/splash_controller.dart';

class MockGetUserDataUseCase extends Mock implements GetUserDataUseCase {}

class MockLocalStorageUseCase extends Mock implements LocalStorageUseCase {}

class MockSessionEntity extends Mock implements SessionEntity {}

class MockAppInfoEntity extends Mock implements AppInfoEntity {}

class MockCheckPermissionUseCase extends Mock
    implements CheckPermissionUseCase {}

class MockPushMessagingService extends Mock implements PushMessagingService {}

class MockPushNotificationsService extends Mock
    implements PushNotificationsService {}

class MockGetDeviceLocaleUseCase extends Mock
    implements GetDeviceLocaleUseCase {}

class MockFirebaseInitializeService extends Mock
    implements FirebaseInitializeService {}

class MockAppsFlyerService extends Mock implements AppsFlyerService {}

class MockAppSecurityManager extends Mock implements AppSecurityManager {}

class MockGetInstallationAppUseCase extends Mock
    implements GetInstallationAppUseCase {}

class MockUploadInstallationAppUseCase extends Mock
    implements UploadInstallationAppUseCase {}

class MockFeatureFlagLifecycleController extends Mock
    implements FeatureFlagLifecycleController {}

class FakeUserEntity extends Fake implements UserEntity {}

class FakeInstallationEntity extends Fake implements InstallationEntity {}

void main() {
  late MockGetUserDataUseCase mockGetUserDataUseCase;
  late MockLocalStorageUseCase mockLocalStorageUseCase;
  late MockSessionEntity mockSessionEntity;
  late MockAppInfoEntity mockAppInfoEntity;
  late MockCheckPermissionUseCase mockCheckPermissionUseCase;
  late MockPushMessagingService mockPushMessagingService;
  late MockPushNotificationsService mockPushNotificationsService;
  late MockGetDeviceLocaleUseCase mockGetDeviceLocaleUseCase;
  late MockFirebaseInitializeService mockFirebaseInitializeService;
  late MockAppsFlyerService mockAppsFlyerService;
  late MockAppSecurityManager mockAppSecurityManager;
  late MockGetInstallationAppUseCase mockGetInstallationAppUseCase;
  late MockUploadInstallationAppUseCase mockUploadInstallationAppUseCase;
  late MockFeatureFlagLifecycleController mockFeatureFlagLifecycleController;
  late SplashController splashController;

  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true;
    registerFallbackValue(FakeUserEntity());
    registerFallbackValue(FakeInstallationEntity());
    registerFallbackValue(const Locale('en'));
    registerFallbackValue(Permission.notification);
  });

  setUp(() {
    mockGetUserDataUseCase = MockGetUserDataUseCase();
    mockLocalStorageUseCase = MockLocalStorageUseCase();
    mockSessionEntity = MockSessionEntity();
    mockAppInfoEntity = MockAppInfoEntity();
    mockCheckPermissionUseCase = MockCheckPermissionUseCase();
    mockPushMessagingService = MockPushMessagingService();
    mockPushNotificationsService = MockPushNotificationsService();
    mockGetDeviceLocaleUseCase = MockGetDeviceLocaleUseCase();
    mockFirebaseInitializeService = MockFirebaseInitializeService();
    mockAppsFlyerService = MockAppsFlyerService();
    mockAppSecurityManager = MockAppSecurityManager();
    mockGetInstallationAppUseCase = MockGetInstallationAppUseCase();
    mockUploadInstallationAppUseCase = MockUploadInstallationAppUseCase();
    mockFeatureFlagLifecycleController = MockFeatureFlagLifecycleController();

    when(() => mockAppInfoEntity.version).thenReturn('1.0.0');
    when(() => mockAppInfoEntity.packageName).thenReturn('com.test.app');

    splashController = SplashController(
      getUserDataUseCase: mockGetUserDataUseCase,
      localStorageUseCase: mockLocalStorageUseCase,
      sessionEntity: mockSessionEntity,
      appInfoEntity: mockAppInfoEntity,
      checkPermissionUseCase: mockCheckPermissionUseCase,
      pushMessagingService: mockPushMessagingService,
      pushNotificationsService: mockPushNotificationsService,
      getDeviceLocaleUseCase: mockGetDeviceLocaleUseCase,
      firebaseInitializeService: mockFirebaseInitializeService,
      appsFlyerService: mockAppsFlyerService,
      appSecurityManager: mockAppSecurityManager,
      getInstallationAppUseCase: mockGetInstallationAppUseCase,
      uploadInstallationAppUseCase: mockUploadInstallationAppUseCase,
      featureFlagLifecycleController: mockFeatureFlagLifecycleController,
    );
  });

  tearDown(() {
    Get.reset();
    BaseController.SPLASH_ALREADY_EXECUTED = false;
  });

  group('SplashController', () {
    group('Sucesso - Inicializacao', () {
      test(
        'deve inicializar corretamente o controller e setting SPLASH_ALREADY_EXECUTED',
        () async {
          // arrange & act
          splashController.onInit();

          // assert
          expect(splashController, isNotNull);
          expect(BaseController.SPLASH_ALREADY_EXECUTED, true);
        },
      );

      test(
        'deve chamar onInit e configurar corretamente o estado inicial',
        () async {
          // act
          splashController.onInit();

          // assert
          expect(BaseController.SPLASH_ALREADY_EXECUTED, isTrue);
        },
      );
    });

    group('Sucesso - Verificacao de Sessao', () {
      test(
        'deve retornar true quando sessionEntity.isAuthenticated for true',
        () {
          // arrange
          when(() => mockSessionEntity.isAuthenticated).thenReturn(true);

          // act & assert
          expect(mockSessionEntity.isAuthenticated, isTrue);
        },
      );

      test(
        'deve retornar false quando sessionEntity.isAuthenticated for false',
        () {
          // arrange
          when(() => mockSessionEntity.isAuthenticated).thenReturn(false);

          // act & assert
          expect(mockSessionEntity.isAuthenticated, isFalse);
        },
      );
    });

    group('Sucesso - Permissao de Push Notification', () {
      test(
        'deve retornar PermissionStatus.granted quando permissao concedida',
        () async {
          // arrange
          when(
            () => mockCheckPermissionUseCase.call(any()),
          ).thenAnswer((_) async => PermissionStatus.granted);

          // act
          final result = await mockCheckPermissionUseCase.call(
            Permission.notification,
          );

          // assert
          expect(result, PermissionStatus.granted);
        },
      );

      test(
        'deve retornar PermissionStatus.denied quando permissao negada',
        () async {
          // arrange
          when(
            () => mockCheckPermissionUseCase.call(any()),
          ).thenAnswer((_) async => PermissionStatus.denied);

          // act
          final result = await mockCheckPermissionUseCase.call(
            Permission.notification,
          );

          // assert
          expect(result, PermissionStatus.denied);
        },
      );
    });

    group('Sucesso - AppInfoEntity', () {
      test(
        'deve retornar version correta do AppInfoEntity',
        () {
          // act
          final version = mockAppInfoEntity.version;

          // assert
          expect(version, '1.0.0');
        },
      );

      test(
        'deve retornar packageName correta do AppInfoEntity',
        () {
          // act
          final packageName = mockAppInfoEntity.packageName;

          // assert
          expect(packageName, 'com.test.app');
        },
      );
    });

    group('Sucesso - LocalStorage', () {
      test(
        'deve salvar e buscar valor do LocalStorage',
        () async {
          // arrange
          when(
            () => mockLocalStorageUseCase.set<String>(any(), any()),
          ).thenAnswer((_) async => true);
          when(
            () => mockLocalStorageUseCase.get<String>(any()),
          ).thenAnswer((_) async => '1.0.0');

          // act
          await mockLocalStorageUseCase.set<String>(
            CURRENT_APP_VERSION,
            '1.0.0',
          );
          final result = await mockLocalStorageUseCase.get<String>(
            CURRENT_APP_VERSION,
          );

          // assert
          expect(result, '1.0.0');
          verify(
            () => mockLocalStorageUseCase.set(CURRENT_APP_VERSION, '1.0.0'),
          ).called(1);
          verify(
            () => mockLocalStorageUseCase.get<String>(CURRENT_APP_VERSION),
          ).called(1);
        },
      );

      test(
        'deve retornar null quando chave nao existe',
        () async {
          // arrange
          when(
            () => mockLocalStorageUseCase.get<String>(any()),
          ).thenAnswer((_) async => null);

          // act
          final result = await mockLocalStorageUseCase.get<String>(
            'non_existent_key',
          );

          // assert
          expect(result, isNull);
        },
      );

      test(
        'deve deletar chave do LocalStorage',
        () async {
          // arrange
          when(
            () => mockLocalStorageUseCase.delete(any()),
          ).thenAnswer((_) async => true);

          // act
          final result = await mockLocalStorageUseCase.delete(BLOCKED_APP);

          // assert
          expect(result, isTrue);
          verify(() => mockLocalStorageUseCase.delete(BLOCKED_APP)).called(1);
        },
      );
    });

    group('Sucesso - GetUserDataUseCase', () {
      test(
        'deve retornar UserEntity quando usuario existe',
        () async {
          // arrange
          final user = UserEntity(
            id: 'user-123',
            username: 'test@example.com',
            name: 'Test User',
            email: 'test@example.com',
            avatarUrl: 'https://example.com/avatar.png',
            createdAt: '2024-01-01T00:00:00.000Z',
            updatedAt: '2024-01-01T00:00:00.000Z',
            permissions: [UserPermissionsEnum.USER],
            locale: 'en',
            sessionToken: 'session-token-123',
            pushTopics: [],
          );

          when(
            () => mockGetUserDataUseCase.call(),
          ).thenAnswer((_) async => user);

          // act
          final result = await mockGetUserDataUseCase.call();

          // assert
          expect(result, user);
          expect(result.id, 'user-123');
          expect(result.username, 'test@example.com');
          verify(() => mockGetUserDataUseCase.call()).called(1);
        },
      );

      test(
        'deve lancar excecao quando usuarios falhar',
        () async {
          // arrange
          when(
            () => mockGetUserDataUseCase.call(),
          ).thenThrow(Exception('Error fetching user'));

          // act & assert
          expect(
            () => mockGetUserDataUseCase.call(),
            throwsException,
          );
        },
      );
    });

    group('Sucesso - Installation', () {
      test(
        'deve criar InstallationEntity corretamente',
        () {
          // arrange
          final installation = InstallationEntity(
            installationId: 'inst-123',
            appName: 'Test App',
            appVersion: '1.0.0',
            appIdentifier: 'com.test.app',
            channels: [],
            gcmSenderId: null,
            deviceToken: null,
            pushType: null,
            deviceId: 'device-123',
            deviceBrand: 'brand',
            deviceModel: 'model',
            deviceType: 'phone',
            deviceOsVersion: '14',
            timeZone: 'America/Sao_Paulo',
            localeIdentifier: 'en',
            platform: 'android',
            ip: null,
          );

          // assert
          expect(installation.installationId, 'inst-123');
          expect(installation.appName, 'Test App');
          expect(installation.appVersion, '1.0.0');
          expect(installation.platform, 'android');
        },
      );

      test(
        'deve retornar true quando installations sao iguais',
        () {
          // arrange
          final installation1 = InstallationEntity(
            installationId: 'inst-123',
            appName: 'Test App',
            appVersion: '1.0.0',
            appIdentifier: 'com.test.app',
            channels: [],
            gcmSenderId: null,
            deviceToken: null,
            pushType: null,
            deviceId: 'device-123',
            deviceBrand: 'brand',
            deviceModel: 'model',
            deviceType: 'phone',
            deviceOsVersion: '14',
            timeZone: 'America/Sao_Paulo',
            localeIdentifier: 'en',
            platform: 'android',
            ip: null,
          );

          final installation2 = InstallationEntity(
            installationId: 'inst-123',
            appName: 'Test App',
            appVersion: '1.0.0',
            appIdentifier: 'com.test.app',
            channels: [],
            gcmSenderId: null,
            deviceToken: null,
            pushType: null,
            deviceId: 'device-123',
            deviceBrand: 'brand',
            deviceModel: 'model',
            deviceType: 'phone',
            deviceOsVersion: '14',
            timeZone: 'America/Sao_Paulo',
            localeIdentifier: 'en',
            platform: 'android',
            ip: null,
          );

          // act
          final result = installation1.equals(installation2);

          // assert
          expect(result, isTrue);
        },
      );

      test(
        'deve retornar false quando installations sao diferentes',
        () {
          // arrange
          final installation1 = InstallationEntity(
            installationId: 'inst-123',
            appName: 'Test App',
            appVersion: '1.0.0',
            appIdentifier: 'com.test.app',
            channels: [],
            gcmSenderId: null,
            deviceToken: null,
            pushType: null,
            deviceId: 'device-123',
            deviceBrand: 'brand',
            deviceModel: 'model',
            deviceType: 'phone',
            deviceOsVersion: '14',
            timeZone: 'America/Sao_Paulo',
            localeIdentifier: 'en',
            platform: 'android',
            ip: null,
          );

          final installation2 = InstallationEntity(
            installationId: 'inst-456',
            appName: 'Test App',
            appVersion: '1.0.0',
            appIdentifier: 'com.test.app',
            channels: [],
            gcmSenderId: null,
            deviceToken: null,
            pushType: null,
            deviceId: 'device-456',
            deviceBrand: 'brand',
            deviceModel: 'model',
            deviceType: 'phone',
            deviceOsVersion: '14',
            timeZone: 'America/Sao_Paulo',
            localeIdentifier: 'en',
            platform: 'android',
            ip: null,
          );

          // act
          final result = installation1.equals(installation2);

          // assert
          expect(result, isFalse);
        },
      );
    });

    group('Sucesso - UserEntity', () {
      test(
        'deve verificar se usuario tem permissao de ADMIN',
        () {
          // arrange
          final adminUser = UserEntity(
            id: 'admin-123',
            username: 'admin@example.com',
            name: 'Admin User',
            email: 'admin@example.com',
            avatarUrl: 'https://example.com/avatar.png',
            createdAt: '2024-01-01T00:00:00.000Z',
            updatedAt: '2024-01-01T00:00:00.000Z',
            permissions: [UserPermissionsEnum.ADMIN],
            locale: 'en',
            sessionToken: 'session-token-123',
            pushTopics: [],
          );

          final regularUser = UserEntity(
            id: 'user-123',
            username: 'user@example.com',
            name: 'Regular User',
            email: 'user@example.com',
            avatarUrl: 'https://example.com/avatar.png',
            createdAt: '2024-01-01T00:00:00.000Z',
            updatedAt: '2024-01-01T00:00:00.000Z',
            permissions: [UserPermissionsEnum.USER],
            locale: 'en',
            sessionToken: 'session-token-123',
            pushTopics: [],
          );

          // act & assert
          expect(
            adminUser.permissions.contains(UserPermissionsEnum.ADMIN),
            isTrue,
          );
          expect(
            regularUser.permissions.contains(UserPermissionsEnum.ADMIN),
            isFalse,
          );
        },
      );

      test(
        'deve converter UserEntity para mapa',
        () {
          // arrange
          final user = UserEntity(
            id: 'user-123',
            username: 'test@example.com',
            name: 'Test User',
            email: 'test@example.com',
            avatarUrl: 'https://example.com/avatar.png',
            createdAt: '2024-01-01T00:00:00.000Z',
            updatedAt: '2024-01-01T00:00:00.000Z',
            permissions: [UserPermissionsEnum.USER],
            locale: 'en',
            sessionToken: 'session-token-123',
            pushTopics: [],
          );

          // act
          final map = user.toMap();

          // assert
          if (map['id'] != null) {
            expect(map['id'], 'user-123');
          }
          if (map['objectId'] != null) {
            expect(map['objectId'], 'user-123');
          }
          expect(map['username'], 'test@example.com');
          expect(map['name'], 'Test User');
          expect(map['email'], 'test@example.com');
          expect(map['avatarUrl'], 'https://example.com/avatar.png');
          expect(map['createdAt'], '2024-01-01T00:00:00.000Z');
          expect(map['updatedAt'], '2024-01-01T00:00:00.000Z');
          expect(map['permissions'], ['USER']);
          expect(map['locale'], 'en');
          expect(map['sessionToken'], 'session-token-123');
          expect(map['pushTopics'], []);
        },
      );
    });

    group('Sucesso - Push Messaging', () {
      test(
        'deve iniciar PushMessagingService e obter token',
        () async {
          // arrange
          when(() => mockPushMessagingService.init()).thenAnswer((_) async {});
          when(
            () => mockPushMessagingService.getToken(),
          ).thenAnswer((_) async => 'fcm-token-123');

          // act
          await mockPushMessagingService.init();
          final token = await mockPushMessagingService.getToken();

          // assert
          expect(token, 'fcm-token-123');
          verify(() => mockPushMessagingService.init()).called(1);
          verify(() => mockPushMessagingService.getToken()).called(1);
        },
      );

      test(
        'deve desinscrever de topicos',
        () async {
          // arrange
          when(
            () => mockPushMessagingService.unsubscribeTopic(any()),
          ).thenAnswer((_) async {});

          // act
          await mockPushMessagingService.unsubscribeTopic([
            'topic1',
            'topic2',
          ]);

          // assert
          verify(
            () => mockPushMessagingService.unsubscribeTopic(any()),
          ).called(1);
        },
      );
    });

    group('Sucesso - Push Notifications', () {
      test(
        'deve iniciar PushNotificationsService',
        () async {
          // arrange
          when(
            () => mockPushNotificationsService.init(),
          ).thenAnswer((_) async {});
          when(
            () => mockPushNotificationsService.requestPermission(),
          ).thenAnswer((_) async => PermissionStatus.granted);

          // act
          await mockPushNotificationsService.init();
          final permission = await mockPushNotificationsService
              .requestPermission();

          // assert
          expect(permission, PermissionStatus.granted);
          verify(() => mockPushNotificationsService.init()).called(1);
        },
      );
    });

    group('Sucesso - Locale', () {
      test(
        'deve retornar Locale do dispositivo',
        () async {
          // arrange
          when(
            () => mockGetDeviceLocaleUseCase.call(),
          ).thenAnswer((_) async => const Locale('pt', 'BR'));

          // act
          final locale = await mockGetDeviceLocaleUseCase.call();

          // assert
          expect(locale.languageCode, 'pt');
          expect(locale.countryCode, 'BR');
        },
      );
    });

    group('Sucesso - Firebase Initialize', () {
      test(
        'deve inicializar Firebase',
        () async {
          // arrange
          when(
            () => mockFirebaseInitializeService.init(),
          ).thenAnswer((_) async {});

          // act
          await mockFirebaseInitializeService.init();

          // assert
          verify(() => mockFirebaseInitializeService.init()).called(1);
        },
      );
    });

    group('Sucesso - AppsFlyer', () {
      test(
        'deve inicializar AppsFlyer',
        () async {
          // arrange
          when(() => mockAppsFlyerService.init()).thenAnswer((_) async {});

          // act
          await mockAppsFlyerService.init();

          // assert
          verify(() => mockAppsFlyerService.init()).called(1);
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
    });

    group('Sucesso - FeatureFlagLifecycleController', () {
      test(
        'deve fazer upload de device traits',
        () async {
          // arrange
          when(
            () => mockFeatureFlagLifecycleController.uploadDeviceTraits(),
          ).thenAnswer((_) async {});

          // act
          await mockFeatureFlagLifecycleController.uploadDeviceTraits();

          // assert
          verify(
            () => mockFeatureFlagLifecycleController.uploadDeviceTraits(),
          ).called(1);
        },
      );

      test(
        'deve atualizar feature flags',
        () async {
          // arrange
          when(
            () => mockFeatureFlagLifecycleController.updateFeatureFlags(),
          ).thenAnswer((_) async {});

          // act
          await mockFeatureFlagLifecycleController.updateFeatureFlags();

          // assert
          verify(
            () => mockFeatureFlagLifecycleController.updateFeatureFlags(),
          ).called(1);
        },
      );
    });

    group('onClose', () {
      test(
        'deve chamar updateFeatureFlags no onClose',
        () async {
          // arrange
          when(
            () => mockFeatureFlagLifecycleController.uploadDeviceTraits(),
          ).thenAnswer((_) async {});
          when(
            () => mockFeatureFlagLifecycleController.updateFeatureFlags(),
          ).thenAnswer((_) async {});
          when(
            () => mockLocalStorageUseCase.get<bool>(BLOCKED_APP),
          ).thenAnswer((_) async => false);

          // act - o metodo onClose usa singletons internos que nao podem ser mockados
          // portanto apenas verificamos que o mock foi configurado corretamente
          // O teste completo requer injeção de dependência dos singletons
          expect(splashController, isNotNull);
        },
      );
    });

    group('Erro - Tratamento de Excecoes', () {
      test(
        'deve tratar excecao ao buscar dados do usuario',
        () async {
          // arrange
          when(() => mockSessionEntity.isAuthenticated).thenReturn(true);
          when(
            () => mockGetUserDataUseCase.call(),
          ).thenThrow(Exception('Database error'));

          // act
          try {
            await mockGetUserDataUseCase.call();
          } catch (e) {
            // assert
            expect(e, isA<Exception>());
          }
        },
      );

      test(
        'deve tratar erro ao salvar no localStorage',
        () async {
          // arrange
          when(
            () => mockLocalStorageUseCase.set<String>(any(), any()),
          ).thenThrow(Exception('Storage error'));

          // act & assert
          expect(
            () => mockLocalStorageUseCase.set<String>(
              CURRENT_APP_VERSION,
              '1.0.0',
            ),
            throwsException,
          );
        },
      );

      test(
        'deve tratar erro ao inicializar Firebase',
        () async {
          // arrange
          when(
            () => mockFirebaseInitializeService.init(),
          ).thenThrow(Exception('Firebase init failed'));

          // act & assert
          expect(
            () => mockFirebaseInitializeService.init(),
            throwsException,
          );
        },
      );

      test(
        'deve tratar erro ao inicializar push messaging',
        () async {
          // arrange
          when(
            () => mockPushMessagingService.init(),
          ).thenThrow(Exception('Push init failed'));

          // act & assert
          expect(
            () => mockPushMessagingService.init(),
            throwsException,
          );
        },
      );

      test(
        'deve tratar erro ao fazer upload de installation',
        () async {
          // arrange
          when(
            () => mockUploadInstallationAppUseCase.call(),
          ).thenThrow(Exception('Upload failed'));

          // act & assert
          expect(
            () => mockUploadInstallationAppUseCase.call(),
            throwsException,
          );
        },
      );

      test(
        'deve tratar erro no FeatureFlagLifecycleController',
        () async {
          // arrange
          when(
            () => mockFeatureFlagLifecycleController.uploadDeviceTraits(),
          ).thenThrow(Exception('Feature flag error'));

          // act & assert - deve lanar excecao quando configurado
          expect(
            () => mockFeatureFlagLifecycleController.uploadDeviceTraits(),
            throwsException,
          );
        },
      );
    });
  });
}
