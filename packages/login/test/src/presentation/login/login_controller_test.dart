import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login/src/presentation/login/login_controller.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockLocalStorageUseCase extends Mock implements LocalStorageUseCase {}

class MockUserAuthStorageUseCase extends Mock
    implements UserAuthStorageUseCase {}

class MockUpdateUserLocaleUseCase extends Mock
    implements UpdateUserLocaleUseCase {}

class MockUploadInstallationAppUseCase extends Mock
    implements UploadInstallationAppUseCase {}

class MockFeatureFlagLifecycleController extends Mock
    implements FeatureFlagLifecycleController {}

class FakeUserEntity extends Fake implements UserEntity {}

class FakeInstallationEntity extends Fake implements InstallationEntity {}

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockLocalStorageUseCase mockLocalStorageUseCase;
  late MockUserAuthStorageUseCase mockUserAuthStorageUseCase;
  late MockUpdateUserLocaleUseCase mockUpdateUserLocaleUseCase;
  late MockUploadInstallationAppUseCase mockUploadInstallationAppUseCase;
  late MockFeatureFlagLifecycleController mockFeatureFlagLifecycleController;
  late LoginController loginController;

  late AppEnvironmentEntity appEnv;
  late AppInfoEntity appInfo;

  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
    AppBinding.testMode(true);
    registerFallbackValue(FakeUserEntity());
    registerFallbackValue(FakeInstallationEntity());
  });

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockLocalStorageUseCase = MockLocalStorageUseCase();
    mockUserAuthStorageUseCase = MockUserAuthStorageUseCase();
    mockUpdateUserLocaleUseCase = MockUpdateUserLocaleUseCase();
    mockUploadInstallationAppUseCase = MockUploadInstallationAppUseCase();
    mockFeatureFlagLifecycleController = MockFeatureFlagLifecycleController();

    appEnv = AppEnvironmentEntity(
      appName: 'Test App',
      androidPackageName: 'com.test.app',
      appleStoreAppId: '123456789',
      permissions: '',
      webBaseHREF: '/',
    );

    appInfo = AppInfoEntity(
      appName: 'Test App',
      packageName: 'com.test.app',
      buildSignature: 'test-signature',
      installerStore: null,
      version: '1.0.0',
      build: '1',
    );

    loginController = LoginController(
      appEnv: appEnv,
      loginUseCase: mockLoginUseCase,
      localStorageUseCase: mockLocalStorageUseCase,
      authStorageUseCase: mockUserAuthStorageUseCase,
      updateUserLocaleUseCase: mockUpdateUserLocaleUseCase,
      uploadInstallationAppUseCase: mockUploadInstallationAppUseCase,
      appInfoEntity: appInfo,
      featureFlagLifecycleController: mockFeatureFlagLifecycleController,
    );
  });

  group('LoginController', () {
    group('Sucesso', () {
      test(
        'deve realizar login com sucesso quando credenciais estao corretas',
        () async {
          // arrange
          const username = 'test@example.com';
          const password = 'password123';

          final user = UserEntity(
            id: 'user-123',
            username: username,
            name: 'Test User',
            email: username,
            avatarUrl: 'https://example.com/avatar.png',
            createdAt: '2024-01-01T00:00:00.000Z',
            updatedAt: '2024-01-01T00:00:00.000Z',
            permissions: [UserPermissionsEnum.USER],
            locale: 'en',
            sessionToken: 'session-token-123',
            pushTopics: [],
          );

          when(
            () => mockLoginUseCase.call(
              username: username,
              password: password,
            ),
          ).thenAnswer((_) async => user);

          when(() => mockUpdateUserLocaleUseCase.call(any())).thenAnswer(
            (_) async {},
          );

          when(() => mockUploadInstallationAppUseCase.call()).thenAnswer(
            (_) async => FakeInstallationEntity(),
          );

          when(
            () => mockLocalStorageUseCase.get<bool>(REMEMBER_ME),
          ).thenAnswer((_) async => false);

          when(
            () => mockUserAuthStorageUseCase.clearCredentials(),
          ).thenAnswer((_) async {});

          // act
          await loginController.login(username: username, password: password);

          // assert
          verify(
            () => mockLoginUseCase.call(
              username: username,
              password: password,
            ),
          ).called(1);

          verify(() => mockUpdateUserLocaleUseCase.call(user)).called(1);

          verify(() => mockUploadInstallationAppUseCase.call()).called(1);

          verify(() => mockUserAuthStorageUseCase.clearCredentials()).called(1);
        },
      );

      test(
        'deve chamar saveCredentials quando rememberMe esta ativado',
        () async {
          // arrange
          const username = 'test@example.com';
          const password = 'password123';

          final user = UserEntity(
            id: 'user-123',
            username: username,
            name: 'Test User',
            email: username,
            avatarUrl: 'https://example.com/avatar.png',
            createdAt: '2024-01-01T00:00:00.000Z',
            updatedAt: '2024-01-01T00:00:00.000Z',
            permissions: [UserPermissionsEnum.USER],
            locale: 'en',
            sessionToken: 'session-token-123',
            pushTopics: [],
          );

          when(
            () => mockLoginUseCase.call(
              username: username,
              password: password,
            ),
          ).thenAnswer((_) async => user);

          when(() => mockUpdateUserLocaleUseCase.call(any())).thenAnswer(
            (_) async {},
          );

          when(() => mockUploadInstallationAppUseCase.call()).thenAnswer(
            (_) async => FakeInstallationEntity(),
          );

          when(
            () => mockLocalStorageUseCase.get<bool>(REMEMBER_ME),
          ).thenAnswer((_) async => false);

          // Configurar mock para aceitar qualquer valor de password (incluindo null)
          when(
            () => mockUserAuthStorageUseCase.saveCredentials(
              username: username,
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async {});

          // Configurar rememberMeInitial antes de chamar login
          loginController.rememberMeInitial.value = true;

          // act
          await loginController.login(username: username, password: password);

          // assert
          verify(
            () => mockUserAuthStorageUseCase.saveCredentials(
              username: username,
              password: any(named: 'password'),
            ),
          ).called(1);
        },
      );
    });

    group('Erro', () {
      test(
        'deve propagar excecao quando loginUseCase falhar',
        () async {
          // arrange
          const username = 'test@example.com';
          const password = 'wrongpassword';

          final exception = BaseException(
            message: 'invalid_credentials',
          );

          when(
            () => mockLoginUseCase.call(
              username: username,
              password: password,
            ),
          ).thenThrow(exception);

          when(() => mockLocalStorageUseCase.delete(any())).thenAnswer(
            (_) async => true,
          );

          // act & assert
          expect(
            () => loginController.login(username: username, password: password),
            throwsA(isA<BaseException>()),
          );

          verify(
            () => mockLoginUseCase.call(
              username: username,
              password: password,
            ),
          ).called(1);
        },
      );

      test(
        'deve propagar excecao de rede quando falha de conexao',
        () async {
          // arrange
          const username = 'test@example.com';
          const password = 'password123';

          final exception = BaseException(
            message: 'network_error',
          );

          when(
            () => mockLoginUseCase.call(
              username: username,
              password: password,
            ),
          ).thenThrow(exception);

          // act & assert
          expect(
            () => loginController.login(username: username, password: password),
            throwsA(isA<BaseException>()),
          );
        },
      );
    });

    group('saveRememberEmail', () {
      test('deve salvar rememberMe como true', () async {
        // arrange
        when(
          () => mockLocalStorageUseCase.set<bool>(REMEMBER_ME, true),
        ).thenAnswer((_) async => true);

        // act
        await loginController.saveRememberEmail(true);

        // assert
        expect(loginController.rememberMeInitial.value, true);

        verify(
          () => mockLocalStorageUseCase.set<bool>(REMEMBER_ME, true),
        ).called(1);
      });

      test('deve salvar rememberMe como false', () async {
        // arrange
        when(
          () => mockLocalStorageUseCase.set<bool>(REMEMBER_ME, false),
        ).thenAnswer((_) async => true);

        // act
        await loginController.saveRememberEmail(false);

        // assert
        expect(loginController.rememberMeInitial.value, false);

        verify(
          () => mockLocalStorageUseCase.set<bool>(REMEMBER_ME, false),
        ).called(1);
      });
    });

    group('Propriedades', () {
      test('deve retornar appInfo corretamente', () {
        // act
        final result = loginController.appInfo;

        // assert
        expect(result, appInfo);
        expect(result.appName, 'Test App');
        expect(result.version, '1.0.0');
      });

      test('deve retornar appName corretamente', () {
        // act
        final result = loginController.appName;

        // assert
        expect(result, 'Test App');
      });
    });
  });
}
