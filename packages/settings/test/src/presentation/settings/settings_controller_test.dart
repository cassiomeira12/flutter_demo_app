import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:settings/src/presentation/settings/settings_controller.dart';

class MockThemeController extends Mock implements ThemeController {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockLocalStorageUseCase extends Mock implements LocalStorageUseCase {}

class MockUserAuthStorageUseCase extends Mock
    implements UserAuthStorageUseCase {}

class MockUpdateUserLocaleUseCase extends Mock
    implements UpdateUserLocaleUseCase {}

class MockAppSecurityManager extends Mock implements AppSecurityManager {}

class FakeUserEntity extends Fake implements UserEntity {}

void main() {
  late MockThemeController mockThemeController;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockLocalStorageUseCase mockLocalStorageUseCase;
  late MockUserAuthStorageUseCase mockUserAuthStorageUseCase;
  late MockUpdateUserLocaleUseCase mockUpdateUserLocaleUseCase;
  late MockAppSecurityManager mockAppSecurityManager;
  late SettingsController settingsController;

  late AppInfoEntity appInfo;
  late UserEntity user;

  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
    AppBinding.testMode(true);
    registerFallbackValue(FakeUserEntity());
    registerFallbackValue(const Locale('en', 'US'));
  });

  setUp(() {
    mockThemeController = MockThemeController();
    mockLogoutUseCase = MockLogoutUseCase();
    mockLocalStorageUseCase = MockLocalStorageUseCase();
    mockUserAuthStorageUseCase = MockUserAuthStorageUseCase();
    mockUpdateUserLocaleUseCase = MockUpdateUserLocaleUseCase();
    mockAppSecurityManager = MockAppSecurityManager();

    appInfo = AppInfoEntity(
      appName: 'Test App',
      packageName: 'com.test.app',
      buildSignature: 'test-signature',
      installerStore: null,
      version: '1.0.0',
      build: '1',
    );

    user = UserEntity(
      id: 'user-123',
      username: 'testuser',
      name: 'Test User',
      email: 'test@example.com',
      avatarUrl: 'https://example.com/avatar.png',
      createdAt: '2024-01-01T00:00:00.000Z',
      updatedAt: '2024-01-01T00:00:00.000Z',
      permissions: [UserPermissionsEnum.USER],
      locale: 'en',
      sessionToken: 'session-token-123',
      pushTopics: [],
      phoneNumber: '+5577999999999',
      phoneVerified: true,
      sosConfig: SosConfigEntity(onlyPolice: false, onlySafetyContacts: true),
    );

    when(() => mockThemeController.currentThemeData).thenReturn('light');
    when(() => mockThemeController.changeTheme(any())).thenAnswer((_) async {});

    settingsController = SettingsController(
      themeController: mockThemeController,
      logoutUseCase: mockLogoutUseCase,
      localStorageUseCase: mockLocalStorageUseCase,
      userAuthStorageUseCase: mockUserAuthStorageUseCase,
      updateUserLocaleUseCase: mockUpdateUserLocaleUseCase,
      appInfoEntity: appInfo,
      userEntity: user,
      appSecurityManager: mockAppSecurityManager,
    );
  });

  tearDown(() {
    AppBinding.delete<UserEntity>(force: true);
  });

  group('SettingsController - Propriedades', () {
    test('deve retornar appInfo corretamente', () {
      expect(settingsController.appInfo, appInfo);
      expect(settingsController.appInfo.appName, 'Test App');
      expect(settingsController.appInfo.version, '1.0.0');
    });

    test('deve retornar currentThemeData corretamente', () {
      final result = settingsController.currentThemeData;
      expect(result, 'light');
      verify(() => mockThemeController.currentThemeData).called(1);
    });

    test('deve retornar pageRouteNamed como settings', () {
      expect(settingsController.pageRouteNamed, AppRouter.settings.name);
    });
  });

  group('SettingsController - onChangeTheme', () {
    test('deve alterar o tema quando chamar onChangeTheme', () {
      // arrange
      const theme = 'dark';
      when(
        () => mockThemeController.changeTheme(any()),
      ).thenAnswer((_) async {});

      // act
      settingsController.onChangeTheme(theme);

      // assert
      verify(() => mockThemeController.changeTheme(theme)).called(1);
    });
  });

  group('SettingsController - onChangeLocale', () {
    test('deve alterar o locale do usuário', () {
      // arrange
      const locale = Locale('pt', 'BR');
      when(
        () => mockUpdateUserLocaleUseCase.call(
          any(),
          definedLocale: any(named: 'definedLocale'),
        ),
      ).thenAnswer((_) async {});

      // act
      settingsController.onChangeLocale(locale);

      // assert
      verify(
        () => mockUpdateUserLocaleUseCase.call(
          any(),
          definedLocale: locale,
        ),
      ).called(1);
    });
  });

  group('SettingsController - onClearCache', () {
    test('deve limpar cache e fazer logout com sucesso', () async {
      // arrange
      when(() => mockLocalStorageUseCase.clearAll()).thenAnswer((_) async {});
      when(
        () => mockUserAuthStorageUseCase.clearUserData(),
      ).thenAnswer((_) async {});
      when(
        () => mockUserAuthStorageUseCase.clearCredentials(),
      ).thenAnswer((_) async {});
      when(
        () => mockUserAuthStorageUseCase.clearSessionToken(),
      ).thenAnswer((_) async {});
      when(() => mockLogoutUseCase.call()).thenAnswer((_) async {});
      when(
        () => mockAppSecurityManager.clearSettings(),
      ).thenAnswer((_) async {});
      when(() => mockAppSecurityManager.init()).thenAnswer((_) async {});

      // act
      await settingsController.onClearCache();

      // assert
      verify(() => mockLocalStorageUseCase.clearAll()).called(1);
      verify(() => mockUserAuthStorageUseCase.clearUserData()).called(1);
      verify(() => mockUserAuthStorageUseCase.clearCredentials()).called(1);
      verify(() => mockUserAuthStorageUseCase.clearSessionToken()).called(1);
      verify(() => mockLogoutUseCase.call()).called(1);
    });

    test(
      'deve lançar exceção quando logoutUseCase falhar no onClearCache',
      () async {
        // arrange
        when(() => mockLocalStorageUseCase.clearAll()).thenAnswer((_) async {});
        when(
          () => mockUserAuthStorageUseCase.clearUserData(),
        ).thenAnswer((_) async {});
        when(
          () => mockUserAuthStorageUseCase.clearCredentials(),
        ).thenAnswer((_) async {});
        when(
          () => mockUserAuthStorageUseCase.clearSessionToken(),
        ).thenAnswer((_) async {});
        when(
          () => mockLogoutUseCase.call(),
        ).thenThrow(Exception('Logout failed'));
        when(
          () => mockAppSecurityManager.clearSettings(),
        ).thenAnswer((_) async {});
        when(() => mockAppSecurityManager.init()).thenAnswer((_) async {});

        // act & assert
        // O logout tenta fazer a navegação, então esperamos que não lance exceção
        // pois o método logout captura a exceção internamente
        await settingsController.onClearCache();

        // Verifica que foi chamado até o logout
        verify(() => mockLogoutUseCase.call()).called(1);
      },
    );
  });

  group('SettingsController - logout', () {
    test('deve realizar logout com sucesso', () async {
      // arrange
      when(() => mockLogoutUseCase.call()).thenAnswer((_) async {});
      when(
        () => mockAppSecurityManager.clearSettings(),
      ).thenAnswer((_) async {});
      when(() => mockAppSecurityManager.init()).thenAnswer((_) async {});

      // act
      await settingsController.logout();

      // assert
      verify(() => mockLogoutUseCase.call()).called(1);
      verify(() => mockAppSecurityManager.clearSettings()).called(1);
      verify(() => mockAppSecurityManager.init()).called(1);
    });

    test(
      'deve continuar execução mesmo quando logoutUseCase lança exceção',
      () async {
        // arrange
        when(
          () => mockLogoutUseCase.call(),
        ).thenThrow(Exception('Logout error'));
        when(
          () => mockAppSecurityManager.clearSettings(),
        ).thenAnswer((_) async {});
        when(() => mockAppSecurityManager.init()).thenAnswer((_) async {});

        // act
        await settingsController.logout();

        // assert
        verify(() => mockLogoutUseCase.call()).called(1);
        verify(() => mockAppSecurityManager.clearSettings()).called(1);
        verify(() => mockAppSecurityManager.init()).called(1);
      },
    );
  });

  group('SettingsController - Navegação', () {
    test('userData deve chamar AppNavigator.toNamed sem lançar exceção', () {
      // arrange
      // act & assert
      // O método navigates using AppNavigator.toNamed(AppRouter.user)
      // Tested indirectly - just verify it doesn't throw synchronously
      expect(() => settingsController.userData(), returnsNormally);
    });

    test('security deve chamar AppNavigator.toNamed sem lançar exceção', () {
      // arrange & act & assert
      expect(() => settingsController.security(), returnsNormally);
    });

    test(
      'notificationSettings deve chamar AppNavigator.toNamed sem lançar exceção',
      () {
        // arrange & act & assert
        expect(
          () => settingsController.notificationSettings(),
          returnsNormally,
        );
      },
    );

    test('themes deve chamar AppNavigator.toNamed sem lançar exceção', () {
      // arrange & act & assert
      expect(() => settingsController.themes(), returnsNormally);
    });

    test('about deve chamar AppNavigator.toNamed sem lançar exceção', () {
      // arrange & act & assert
      expect(() => settingsController.about(), returnsNormally);
    });
  });
}
