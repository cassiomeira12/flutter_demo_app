import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

// Mock for UserDataSource - implementação manual
class FakeUserDataSource implements UserDataSource {
  Map<String, dynamic>? mockUserData;
  Exception? mockError;
  String? lastReason;
  String? lastObjectId;
  Map<String, dynamic>? lastData;
  String? lastUsername;
  String? lastCurrentPassword;
  String? lastNewPassword;

  @override
  Future<Map<String, dynamic>> getUserData() async {
    if (mockError != null) {
      throw mockError!;
    }
    return mockUserData!;
  }

  @override
  Future<void> updateUserData({
    required String objectId,
    required Map<String, dynamic> data,
  }) async {
    lastObjectId = objectId;
    lastData = data;
    if (mockError != null) {
      throw mockError!;
    }
  }

  @override
  Future<void> deleteUser({required String reason}) async {
    lastReason = reason;
    if (mockError != null) {
      throw mockError!;
    }
  }

  @override
  Future<Map<String, dynamic>> changePassword({
    required String username,
    required String currentPassword,
    required String newPassword,
  }) async {
    lastUsername = username;
    lastCurrentPassword = currentPassword;
    lastNewPassword = newPassword;
    if (mockError != null) {
      throw mockError!;
    }
    return mockUserData!;
  }
}

void main() {
  late FakeUserDataSource fakeDataSource;
  late UserServiceImpl service;

  setUp(() {
    fakeDataSource = FakeUserDataSource();
    service = UserServiceImpl(userDataSource: fakeDataSource);
  });

  group('UserServiceImpl - getUserData', () {
    group('Sucesso', () {
      test(
        'deve retornar UserModel quando dataSource retorna dados válidos',
        () async {
          // arrange
          fakeDataSource.mockUserData = <String, dynamic>{
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
          final result = await service.getUserData();
          // assert
          expect(result, isA<UserModel>());
          expect(result.id, 'user-123');
          expect(result.username, 'testuser');
          expect(result.sessionToken, 'token-123');
        },
      );

      test('deve retornar UserModel com todos os dados', () async {
        // arrange
        fakeDataSource.mockUserData = <String, dynamic>{
          'objectId': 'user-full',
          'username': 'fulluser',
          'name': 'Full User',
          'email': 'full@example.com',
          'avatarUrl': 'https://example.com/full.png',
          'createdAt': '2024-02-01T00:00:00Z',
          'updatedAt': '2024-02-01T00:00:00Z',
          'permissions': <String>['ADMIN', 'USER'],
          'locale': 'pt_BR',
          'sessionToken': 'full-token',
          'pushTopics': <String>['news', 'promotions'],
        };
        // act
        final result = await service.getUserData();
        // assert
        expect(result.email, 'full@example.com');
        expect(result.permissions.contains(UserPermissionsEnum.ADMIN), isTrue);
        expect(result.permissions.contains(UserPermissionsEnum.USER), isTrue);
        expect(result.pushTopics, ['news', 'promotions']);
      });
    });

    group('Erro', () {
      test('deve lançar exceção quando HttpException for lançada', () async {
        // arrange
        fakeDataSource.mockError = HttpException(
          statusCode: 500,
          message: 'Internal server error',
        );
        // act & assert
        expect(
          () => service.getUserData(),
          throwsA(isA<Exception>()),
        );
      });

      test(
        'deve lançar BaseException quando dataSource lançar BaseException',
        () async {
          // arrange
          fakeDataSource.mockError = BaseException(
            error: Exception('Service unavailable'),
          );
          // act & assert
          expect(
            () => service.getUserData(),
            throwsA(isA<BaseException>()),
          );
        },
      );

      test('deve lançar BaseException quando ocorrer erro genérico', () async {
        // arrange
        fakeDataSource.mockError = Exception('Network error');
        // act & assert
        expect(
          () => service.getUserData(),
          throwsA(isA<BaseException>()),
        );
      });
    });
  });

  group('UserServiceImpl - deleteUser', () {
    group('Sucesso', () {
      test('deve chamar dataSource deleteUser com reason', () async {
        // arrange
        // act
        await service.deleteUser('User requested deletion');
        // assert
        expect(fakeDataSource.lastReason, 'User requested deletion');
      });

      test('deve retornar sem erro quando deletado com sucesso', () async {
        // arrange & act & assert
        expect(
          () => service.deleteUser('reason'),
          returnsNormally,
        );
      });
    });

    group('Erro', () {
      test('deve lançar exceção quando HttpException for lançada', () async {
        // arrange
        fakeDataSource.mockError = HttpException(
          statusCode: 500,
          message: 'Delete failed',
        );
        // act & assert
        expect(
          () => service.deleteUser('reason'),
          throwsA(isA<Exception>()),
        );
      });

      test(
        'deve lançar BaseException quando dataSource lançar BaseException',
        () async {
          // arrange
          fakeDataSource.mockError = BaseException(
            error: Exception('Service unavailable'),
          );
          // act & assert
          expect(
            () => service.deleteUser('reason'),
            throwsA(isA<BaseException>()),
          );
        },
      );

      test('deve lançar BaseException quando ocorrer erro genérico', () async {
        // arrange
        fakeDataSource.mockError = Exception('Network error');
        // act & assert
        expect(
          () => service.deleteUser('reason'),
          throwsA(isA<BaseException>()),
        );
      });
    });
  });

  group('UserServiceImpl - update', () {
    group('Sucesso', () {
      test(
        'deve atualizar dados do usuário e retornar novo getUserData',
        () async {
          // arrange
          fakeDataSource.mockUserData = <String, dynamic>{
            'objectId': 'user-123',
            'username': 'updateduser',
            'name': 'Updated User',
            'email': 'updated@example.com',
            'avatarUrl': '',
            'createdAt': '2024-01-01T00:00:00Z',
            'updatedAt': '2024-01-02T00:00:00Z',
            'permissions': <String>[],
            'locale': 'pt_BR',
            'sessionToken': 'new-token',
            'pushTopics': <String>[],
          };
          // act
          final result = await service.update(
            'user-123',
            data: {'name': 'Updated User', 'locale': 'pt_BR'},
          );
          // assert
          expect(result, isA<UserModel>());
          expect(fakeDataSource.lastObjectId, 'user-123');
          expect(fakeDataSource.lastData?['name'], 'Updated User');
          expect(fakeDataSource.lastData?['locale'], 'pt_BR');
        },
      );
    });

    group('Erro', () {
      test('deve lançar BaseException quando dataSource falhar', () async {
        // arrange
        fakeDataSource.mockError = BaseException(
          error: Exception('Update failed'),
        );
        // act & assert
        expect(
          () => service.update('user-123', data: {'name': 'Test'}),
          throwsA(isA<BaseException>()),
        );
      });
    });
  });

  group('UserServiceImpl - changePassword', () {
    group('Sucesso', () {
      test('deve retornar UserModel quando password for alterada', () async {
        // arrange
        fakeDataSource.mockUserData = <String, dynamic>{
          'objectId': 'user-123',
          'username': 'testuser',
          'name': 'Test User',
          'email': 'test@example.com',
          'avatarUrl': '',
          'createdAt': '2024-01-01T00:00:00Z',
          'updatedAt': '2024-01-01T00:00:00Z',
          'permissions': <String>[],
          'locale': 'en_US',
          'sessionToken': 'new-token',
          'pushTopics': <String>[],
        };
        // act
        final result = await service.changePassword(
          username: 'testuser',
          currentPassword: 'oldpass',
          newPassword: 'newpass',
        );
        // assert
        expect(result, isA<UserModel>());
        expect(fakeDataSource.lastUsername, 'testuser');
        expect(fakeDataSource.lastCurrentPassword, 'oldpass');
        expect(fakeDataSource.lastNewPassword, 'newpass');
      });
    });

    group('Erro', () {
      test('deve lançar exceção quando HttpException for lançada', () async {
        // arrange
        fakeDataSource.mockError = HttpException(
          statusCode: 401,
          message: 'Unauthorized',
        );
        // act & assert
        expect(
          () => service.changePassword(
            username: 'user',
            currentPassword: 'old',
            newPassword: 'new',
          ),
          throwsA(isA<Exception>()),
        );
      });

      test(
        'deve lançar BaseException quando dataSource lançar BaseException',
        () async {
          // arrange
          fakeDataSource.mockError = BaseException(
            error: Exception('Service unavailable'),
          );
          // act & assert
          expect(
            () => service.changePassword(
              username: 'user',
              currentPassword: 'old',
              newPassword: 'new',
            ),
            throwsA(isA<BaseException>()),
          );
        },
      );

      test('deve lançar BaseException quando ocorrer erro genérico', () async {
        // arrange
        fakeDataSource.mockError = Exception('Network error');
        // act & assert
        expect(
          () => service.changePassword(
            username: 'user',
            currentPassword: 'old',
            newPassword: 'new',
          ),
          throwsA(isA<BaseException>()),
        );
      });
    });
  });
}
