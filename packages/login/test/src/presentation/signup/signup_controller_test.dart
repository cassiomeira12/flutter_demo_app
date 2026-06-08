import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login/src/domain/domain.dart';
import 'package:login/src/presentation/signup/signup_controller.dart';

class MockCreateUserUseCase extends Mock implements CreateUserUseCase {}

class MockUpdateUserLocaleUseCase extends Mock
    implements UpdateUserLocaleUseCase {}

class MockUploadInstallationAppUseCase extends Mock
    implements UploadInstallationAppUseCase {}

class MockOpenWebUrlUseCase extends Mock implements OpenWebUrlUseCase {}

class FakeUserEntity extends Fake implements UserEntity {}

void main() {
  late MockCreateUserUseCase mockCreateUserUseCase;
  late MockUpdateUserLocaleUseCase mockUpdateUserLocaleUseCase;
  late MockUploadInstallationAppUseCase mockUploadInstallationAppUseCase;
  late MockOpenWebUrlUseCase mockOpenWebUrlUseCase;
  late SignUpController Subject;

  final testUser = UserEntity(
    id: 'user_123',
    username: 'test@example.com',
    name: 'Test User',
    email: 'test@example.com',
    avatarUrl: 'https://example.com/avatar.png',
    createdAt: '2024-01-01T00:00:00Z',
    updatedAt: '2024-01-01T00:00:00Z',
    permissions: [],
    locale: 'en-US',
    sessionToken: 'token123',
    pushTopics: [],
  );

  final testInstallation = InstallationEntity(
    installationId: 'inst_123',
    appName: 'TestApp',
    appVersion: '1.0.0',
    appIdentifier: 'com.test.app',
    channels: ['stable'],
    gcmSenderId: 'sender123',
    deviceToken: 'device_token',
    pushType: 'fcm',
    deviceId: 'device_123',
    deviceBrand: 'Apple',
    deviceModel: 'iPhone',
    deviceType: 'phone',
    deviceOsVersion: '17.0',
    timeZone: 'America/Sao_Paulo',
    localeIdentifier: 'en-US',
    platform: 'ios',
    ip: '127.0.0.1',
  );

  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
    AppBinding.testMode(true);
    registerFallbackValue(FakeUserEntity());
  });

  setUp(() {
    mockCreateUserUseCase = MockCreateUserUseCase();
    mockUpdateUserLocaleUseCase = MockUpdateUserLocaleUseCase();
    mockUploadInstallationAppUseCase = MockUploadInstallationAppUseCase();
    mockOpenWebUrlUseCase = MockOpenWebUrlUseCase();

    Subject = SignUpController(
      createUserUseCase: mockCreateUserUseCase,
      updateUserLocaleUseCase: mockUpdateUserLocaleUseCase,
      uploadInstallationAppUseCase: mockUploadInstallationAppUseCase,
      openWebUrlUseCase: mockOpenWebUrlUseCase,
    );
  });

  group('SignUpController - Sucesso', () {
    test(
      'deve criar usuário e navegar para home quando signUp for bem sucedido',
      () async {
        when(
          () => mockCreateUserUseCase.call(
            name: any(named: 'name'),
            email: any(named: 'email'),
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => testUser);

        when(
          () => mockUpdateUserLocaleUseCase.call(any()),
        ).thenAnswer((_) async => {});
        when(
          () => mockUploadInstallationAppUseCase.call(),
        ).thenAnswer((_) async => testInstallation);

        await Subject.signUp(
          name: 'Test User',
          email: 'test@example.com',
          password: 'password123',
        );

        verify(
          () => mockCreateUserUseCase.call(
            name: 'Test User',
            email: 'test@example.com',
            username: 'test@example.com',
            password: 'password123',
          ),
        ).called(1);

        verify(() => mockUpdateUserLocaleUseCase.call(testUser)).called(1);
        verify(() => mockUploadInstallationAppUseCase.call()).called(1);
      },
    );

    test('deve chamar updateUserLocaleUseCase após criar usuário', () async {
      when(
        () => mockCreateUserUseCase.call(
          name: any(named: 'name'),
          email: any(named: 'email'),
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => testUser);

      when(
        () => mockUpdateUserLocaleUseCase.call(any()),
      ).thenAnswer((_) async => {});
      when(
        () => mockUploadInstallationAppUseCase.call(),
      ).thenAnswer((_) async => testInstallation);

      await Subject.signUp(
        name: 'Test User',
        email: 'test@example.com',
        password: 'password123',
      );

      verify(() => mockUpdateUserLocaleUseCase.call(testUser)).called(1);
    });

    test(
      'deve chamar uploadInstallationAppUseCase após criar usuário',
      () async {
        when(
          () => mockCreateUserUseCase.call(
            name: any(named: 'name'),
            email: any(named: 'email'),
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => testUser);

        when(
          () => mockUpdateUserLocaleUseCase.call(any()),
        ).thenAnswer((_) async => {});
        when(
          () => mockUploadInstallationAppUseCase.call(),
        ).thenAnswer((_) async => testInstallation);

        await Subject.signUp(
          name: 'Test User',
          email: 'test@example.com',
          password: 'password123',
        );

        verify(() => mockUploadInstallationAppUseCase.call()).called(1);
      },
    );
  });

  group('SignUpController - Erro', () {
    test('deve lançar exceção quando CreateUserUseCase falhar', () async {
      when(
        () => mockCreateUserUseCase.call(
          name: any(named: 'name'),
          email: any(named: 'email'),
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      ).thenThrow(Exception('Falha ao criar usuário'));

      expect(
        () => Subject.signUp(
          name: 'Test User',
          email: 'test@example.com',
          password: 'password123',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test(
      'deve continuar executando quando UpdateUserLocaleUseCase falhar',
      () async {
        when(
          () => mockCreateUserUseCase.call(
            name: any(named: 'name'),
            email: any(named: 'email'),
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => testUser);

        when(
          () => mockUpdateUserLocaleUseCase.call(any()),
        ).thenThrow(Exception('Erro ao atualizar locale'));
        when(
          () => mockUploadInstallationAppUseCase.call(),
        ).thenAnswer((_) async => testInstallation);

        await Subject.signUp(
          name: 'Test User',
          email: 'test@example.com',
          password: 'password123',
        );

        verify(() => mockUpdateUserLocaleUseCase.call(testUser)).called(1);
        verify(() => mockUploadInstallationAppUseCase.call()).called(1);
      },
    );

    test(
      'deve continuar executando quando UploadInstallationAppUseCase falhar',
      () async {
        when(
          () => mockCreateUserUseCase.call(
            name: any(named: 'name'),
            email: any(named: 'email'),
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => testUser);

        when(
          () => mockUpdateUserLocaleUseCase.call(any()),
        ).thenAnswer((_) async => {});
        when(
          () => mockUploadInstallationAppUseCase.call(),
        ).thenThrow(Exception('Erro ao enviar instalação'));

        await Subject.signUp(
          name: 'Test User',
          email: 'test@example.com',
          password: 'password123',
        );

        verify(
          () => mockCreateUserUseCase.call(
            name: any(named: 'name'),
            email: any(named: 'email'),
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).called(1);
      },
    );
  });

  group('SignUpController - termsConditions', () {
    test('deve abrir URL de termos e condições', () {
      when(() => mockOpenWebUrlUseCase.call(any())).thenAnswer((_) async {});

      Subject.termsConditions();

      verify(() => mockOpenWebUrlUseCase.call(any())).called(1);
    });
  });

  group('SignUpController - privacyPolicy', () {
    test('deve abrir URL de política de privacidade', () {
      when(() => mockOpenWebUrlUseCase.call(any())).thenAnswer((_) async {});

      Subject.privacyPolicy();

      verify(() => mockOpenWebUrlUseCase.call(any())).called(1);
    });
  });
}
