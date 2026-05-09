import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

// Mock for LoginDataSource - implementação manual
class FakeLoginDataSource implements LoginDataSource {
  Map<String, dynamic>? mockResponse;
  Exception? mockError;
  String? lastUsername;
  String? lastPassword;

  @override
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    lastUsername = username;
    lastPassword = password;
    if (mockError != null) {
      throw mockError!;
    }
    return mockResponse!;
  }
}

// Mock for EncryptServerPublicKeyUseCase - implementação manual
class FakeEncryptServerPublicKeyUseCase
    implements EncryptServerPublicKeyUseCase {
  String? mockEncryptedPassword;
  Exception? mockError;
  String? lastInput;

  @override
  Future<String> call(String data) async {
    lastInput = data;
    if (mockError != null) {
      throw mockError!;
    }
    return mockEncryptedPassword ?? 'encrypted_$data';
  }
}

void main() {
  late FakeLoginDataSource fakeDataSource;
  late FakeEncryptServerPublicKeyUseCase fakeEncryptUseCase;
  late LoginServiceImpl service;

  setUp(() {
    fakeDataSource = FakeLoginDataSource();
    fakeEncryptUseCase = FakeEncryptServerPublicKeyUseCase();
    service = LoginServiceImpl(
      loginDataSource: fakeDataSource,
      encryptServerPublicKeyUseCase: fakeEncryptUseCase,
    );
  });

  group('LoginServiceImpl - login', () {
    group('Sucesso', () {
      test('deve retornar UserModel quando login for bem-sucedido', () async {
        // arrange
        fakeDataSource.mockResponse = <String, dynamic>{
          'objectId': 'user-123',
          'username': 'testuser',
          'name': 'Test User',
          'email': 'test@example.com',
          'avatarUrl': 'https://example.com/avatar.png',
          'createdAt': '2024-01-01T00:00:00Z',
          'updatedAt': '2024-01-01T00:00:00Z',
          'permissions': <String>[],
          'locale': 'en_US',
          'sessionToken': 'token-123',
          'pushTopics': <String>[],
        };
        // act
        final result = await service.login(
          username: 'testuser',
          password: 'password123',
        );
        // assert
        expect(result, isA<UserModel>());
        expect(result.id, 'user-123');
        expect(result.username, 'testuser');
        expect(result.sessionToken, 'token-123');
      });

      test('deve encryptar senha antes de enviar para dataSource', () async {
        // arrange
        fakeEncryptUseCase.mockEncryptedPassword = 'encrypted_test_password';
        fakeDataSource.mockResponse = <String, dynamic>{
          'objectId': 'user-456',
          'username': 'johndoe',
          'name': 'John Doe',
          'email': 'john@example.com',
          'avatarUrl': 'https://example.com/john.png',
          'createdAt': '2024-02-01T00:00:00Z',
          'updatedAt': '2024-02-01T00:00:00Z',
          'permissions': <String>['USER'],
          'locale': 'pt_BR',
          'sessionToken': 'token-456',
          'pushTopics': <String>['news'],
        };
        // act
        await service.login(
          username: 'johndoe',
          password: 'mySecretPassword',
        );
        // assert
        expect(fakeEncryptUseCase.lastInput, 'mySecretPassword');
        expect(fakeDataSource.lastPassword, 'encrypted_test_password');
      });

      test('deve retornar UserModel com todos os campos preenchidos', () async {
        // arrange
        fakeDataSource.mockResponse = <String, dynamic>{
          'objectId': 'user-full',
          'username': 'fulluser',
          'name': 'Full User',
          'email': 'full@example.com',
          'avatarUrl': 'https://example.com/full.png',
          'createdAt': '2024-03-01T00:00:00Z',
          'updatedAt': '2024-03-01T00:00:00Z',
          'permissions': <String>['ADMIN', 'USER'],
          'locale': 'en_US',
          'sessionToken': 'full-token',
          'pushTopics': <String>['updates', 'promotions'],
        };
        // act
        final result = await service.login(
          username: 'fulluser',
          password: 'password',
        );
        // assert
        expect(result.email, 'full@example.com');
        expect(result.locale, 'en_US');
        expect(result.pushTopics, ['updates', 'promotions']);
      });

      test('deve passar username corretamente para dataSource', () async {
        // arrange
        fakeDataSource.mockResponse = <String, dynamic>{
          'objectId': 'user-test',
          'username': 'testuser',
          'name': 'Test',
          'email': 'test@test.com',
          'avatarUrl': '',
          'createdAt': '2024-01-01T00:00:00Z',
          'updatedAt': '2024-01-01T00:00:00Z',
          'permissions': <String>[],
          'locale': 'en',
          'sessionToken': 'token',
          'pushTopics': <String>[],
        };
        // act
        await service.login(username: 'myuser', password: 'mypass');
        // assert
        expect(fakeDataSource.lastUsername, 'myuser');
      });
    });

    group('Erro', () {
      test(
        'deve lançar exceção quando HttpException for lançada pelo dataSource',
        () async {
          // arrange
          fakeDataSource.mockError = HttpException(
            statusCode: 401,
            message: 'Unauthorized',
          );
          // act & assert
          expect(
            () => service.login(username: 'user', password: 'pass'),
            throwsA(isA<Exception>()),
          );
        },
      );

      test(
        'deve lançar BaseException quando dataSource lançar BaseException',
        () async {
          // arrange
          fakeDataSource.mockError = BaseException(
            error: Exception('Service unavailable'),
          );
          // act & assert
          expect(
            () => service.login(username: 'user', password: 'pass'),
            throwsA(isA<BaseException>()),
          );
        },
      );

      test('deve lançar BaseException quando ocorrer erro genérico', () async {
        // arrange
        fakeDataSource.mockError = Exception('Network error');
        // act & assert
        expect(
          () => service.login(username: 'user', password: 'pass'),
          throwsA(isA<BaseException>()),
        );
      });

      test('deve relançar BaseException quando já for BaseException', () async {
        // arrange
        fakeDataSource.mockError = BaseException(
          error: Exception('Invalid credentials'),
        );
        // act & assert
        expect(
          () => service.login(username: 'user', password: 'pass'),
          throwsA(isA<BaseException>()),
        );
      });

      test('deve lançar BaseException quando encryptUseCase falhar', () async {
        // arrange
        fakeEncryptUseCase.mockError = Exception('Encryption failed');
        // act & assert
        expect(
          () => service.login(username: 'user', password: 'pass'),
          throwsA(isA<BaseException>()),
        );
      });
    });
  });
}
