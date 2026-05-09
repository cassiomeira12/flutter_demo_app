import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserModel', () {
    test('should create UserModel with all required fields', () {
      final model = UserModel(
        id: 'user-123',
        username: 'john_doe',
        name: 'John Doe',
        email: 'john@example.com',
        avatarUrl: 'https://example.com/avatar.png',
        createdAt: '2024-01-01T00:00:00Z',
        updatedAt: '2024-01-02T00:00:00Z',
        permissions: [UserPermissionsEnum.ADMIN, UserPermissionsEnum.USER],
        locale: 'en_US',
        sessionToken: 'token-123',
        pushTopics: ['news', 'updates'],
      );

      expect(model.id, 'user-123');
      expect(model.username, 'john_doe');
      expect(model.name, 'John Doe');
      expect(model.email, 'john@example.com');
      expect(model.avatarUrl, 'https://example.com/avatar.png');
      expect(model.createdAt, '2024-01-01T00:00:00Z');
      expect(model.updatedAt, '2024-01-02T00:00:00Z');
      expect(model.permissions, [
        UserPermissionsEnum.ADMIN,
        UserPermissionsEnum.USER,
      ]);
      expect(model.locale, 'en_US');
      expect(model.sessionToken, 'token-123');
      expect(model.pushTopics, ['news', 'updates']);
    });

    test('should create UserModel from valid map with objectId', () {
      final map = <String, dynamic>{
        'objectId': 'user-456',
        'username': 'jane_doe',
        'name': 'Jane Doe',
        'email': 'jane@example.com',
        'avatarUrl': 'https://example.com/jane.png',
        'createdAt': '2024-02-01T00:00:00Z',
        'updatedAt': '2024-02-02T00:00:00Z',
        'permissions': ['ADMIN', 'USER'],
        'locale': 'pt_BR',
        'sessionToken': 'token-456',
        'pushTopics': ['promotions'],
      };

      final model = UserModel.fromMap(map);

      expect(model.id, 'user-456');
      expect(model.username, 'jane_doe');
      expect(model.name, 'Jane Doe');
      expect(model.email, 'jane@example.com');
      expect(model.locale, 'pt_BR');
      expect(model.sessionToken, 'token-456');
      expect(model.pushTopics, ['promotions']);
    });

    test('should use id field when objectId is not present', () {
      final map = <String, dynamic>{
        'id': 'user-789',
        'username': 'bob',
        'name': 'Bob Smith',
        'email': 'bob@example.com',
        'avatarUrl': 'https://example.com/bob.png',
        'createdAt': '2024-03-01T00:00:00Z',
        'updatedAt': '2024-03-02T00:00:00Z',
        'permissions': [],
        'locale': 'en_US',
        'sessionToken': 'token-789',
        'pushTopics': [],
      };

      final model = UserModel.fromMap(map);

      expect(model.id, 'user-789');
    });

    test('should generate avatarUrl from first name when not provided', () {
      final map = <String, dynamic>{
        'objectId': 'user-avatar',
        'username': 'alice',
        'name': 'Alice Johnson',
        'email': 'alice@example.com',
        'createdAt': '2024-04-01T00:00:00Z',
        'updatedAt': '2024-04-02T00:00:00Z',
        'permissions': [],
        'locale': 'en_US',
        'sessionToken': 'token-avatar',
        'pushTopics': [],
      };

      final model = UserModel.fromMap(map);

      expect(model.avatarUrl, contains('Alice'));
      expect(model.avatarUrl, contains('ui-avatars.com'));
    });

    test(
      'should fallback to email for username when username is not present',
      () {
        final map = <String, dynamic>{
          'objectId': 'user-fallback',
          'name': 'Charlie Brown',
          'email': 'charlie@example.com',
          'avatarUrl': 'https://example.com/charlie.png',
          'createdAt': '2024-05-01T00:00:00Z',
          'updatedAt': '2024-05-02T00:00:00Z',
          'permissions': [],
          'locale': 'en_US',
          'sessionToken': 'token-fallback',
          'pushTopics': [],
        };

        final model = UserModel.fromMap(map);

        expect(model.username, 'charlie@example.com');
      },
    );

    test('should fallback to username for email when email is not present', () {
      final map = <String, dynamic>{
        'objectId': 'user-email-fallback',
        'username': 'dave_user',
        'name': 'Dave Wilson',
        'avatarUrl': 'https://example.com/dave.png',
        'createdAt': '2024-06-01T00:00:00Z',
        'updatedAt': '2024-06-02T00:00:00Z',
        'permissions': [],
        'locale': 'en_US',
        'sessionToken': 'token-email',
        'pushTopics': [],
      };

      final model = UserModel.fromMap(map);

      expect(model.email, 'dave_user');
    });

    test('should map permissions correctly', () {
      final map = <String, dynamic>{
        'objectId': 'user-perms',
        'username': 'admin_user',
        'name': 'Admin User',
        'email': 'admin@example.com',
        'avatarUrl': 'https://example.com/admin.png',
        'createdAt': '2024-07-01T00:00:00Z',
        'updatedAt': '2024-07-02T00:00:00Z',
        'permissions': ['ADMIN', 'USER'],
        'locale': 'en_US',
        'sessionToken': 'token-perms',
        'pushTopics': [],
      };

      final model = UserModel.fromMap(map);

      expect(model.permissions, contains(UserPermissionsEnum.ADMIN));
      expect(model.permissions, contains(UserPermissionsEnum.USER));
    });

    test('should default to USER permission for unknown permissions', () {
      final map = <String, dynamic>{
        'objectId': 'user-unknown-perm',
        'username': 'test_user',
        'name': 'Test User',
        'email': 'test@example.com',
        'avatarUrl': 'https://example.com/test.png',
        'createdAt': '2024-08-01T00:00:00Z',
        'updatedAt': '2024-08-02T00:00:00Z',
        'permissions': ['UNKNOWN_PERMISSION'],
        'locale': 'en_US',
        'sessionToken': 'token-unknown',
        'pushTopics': [],
      };

      final model = UserModel.fromMap(map);

      expect(model.permissions, contains(UserPermissionsEnum.USER));
    });

    test('should handle empty permissions list', () {
      final map = <String, dynamic>{
        'objectId': 'user-no-perms',
        'username': 'no_perms',
        'name': 'No Perms',
        'email': 'noperms@example.com',
        'avatarUrl': 'https://example.com/noperms.png',
        'createdAt': '2024-09-01T00:00:00Z',
        'updatedAt': '2024-09-02T00:00:00Z',
        'permissions': [],
        'locale': 'en_US',
        'sessionToken': 'token-no-perms',
        'pushTopics': [],
      };

      final model = UserModel.fromMap(map);

      expect(model.permissions, isEmpty);
    });

    test('should use nome field when name is not present', () {
      final map = <String, dynamic>{
        'objectId': 'user-nome',
        'username': 'nome_user',
        'nome': 'Carlos Silva',
        'email': 'carlos@example.com',
        'avatarUrl': 'https://example.com/carlos.png',
        'createdAt': '2024-10-01T00:00:00Z',
        'updatedAt': '2024-10-02T00:00:00Z',
        'permissions': [],
        'locale': 'pt_BR',
        'sessionToken': 'token-nome',
        'pushTopics': [],
      };

      final model = UserModel.fromMap(map);

      expect(model.name, 'Carlos Silva');
    });

    test('should use token field when sessionToken is not present', () {
      final map = <String, dynamic>{
        'objectId': 'user-token',
        'username': 'token_user',
        'name': 'Token User',
        'email': 'token@example.com',
        'avatarUrl': 'https://example.com/token.png',
        'createdAt': '2024-11-01T00:00:00Z',
        'updatedAt': '2024-11-02T00:00:00Z',
        'permissions': [],
        'locale': 'en_US',
        'token': 'fallback-token',
        'pushTopics': [],
      };

      final model = UserModel.fromMap(map);

      expect(model.sessionToken, 'fallback-token');
    });

    test('should throw BaseException when fromMap receives invalid map', () {
      final invalidMap = <String, dynamic>{};

      expect(
        () => UserModel.fromMap(invalidMap),
        throwsA(isA<BaseException>()),
      );
    });
  });
}
