import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AuthMiddleware authMiddleware;
  late SessionEntity sessionEntity;
  late UserEntity userEntity;

  setUpAll(() {
    AppBinding.testMode(true);
  });

  setUp(() {
    authMiddleware = AuthMiddleware();
    AppBinding.reset();
    sessionEntity = SessionEntity(token: 'test_token_123');
    userEntity = UserEntity(
      id: 'user_id_123',
      username: 'testuser',
      name: 'Test User',
      email: 'test@example.com',
      avatarUrl: 'https://example.com/avatar.png',
      createdAt: '2024-01-01T00:00:00Z',
      updatedAt: '2024-01-01T00:00:00Z',
      permissions: [UserPermissionsEnum.USER],
      locale: 'en',
      sessionToken: 'test_token_123',
      pushTopics: <String>[],
    );
  });

  tearDown(() {
    AppBinding.reset();
  });

  group('AuthMiddleware - Sem sessão', () {
    test('deve redirecionar para splash quando não houver sessão', () {
      // arrange
      // Sem sessão registrada

      // act
      final result = authMiddleware.redirect('/home');

      // assert
      expect(result, isNotNull);
      expect(result!.name, equals(AppRouter.splash.name));
    });
  });

  group('AuthMiddleware - Com sessão, sem usuário', () {
    test(
      'deve redirecionar para home quando houver sessão mas não houver usuário (rota login não configurada)',
      () {
        // arrange
        AppBinding.put<SessionEntity>(sessionEntity);

        // act
        final result = authMiddleware.redirect('/home');

        // assert
        // Como AppRoutes.findByRoute retorna null no ambiente de teste (rotas não configuradas),
        // o middleware redireciona para home
        expect(result, isNotNull);
        expect(result!.name, equals(AppRouter.home.name));
      },
    );

    test('deve retornar null quando já estiver na rota de login', () {
      // arrange
      AppBinding.put<SessionEntity>(sessionEntity);

      // act
      final result = authMiddleware.redirect(AppRouter.login.name);

      // assert
      expect(result, isNull);
    });

    test('deve redirecionar para home quando rota de login não existir', () {
      // arrange
      AppBinding.put<SessionEntity>(sessionEntity);

      // act
      final result = authMiddleware.redirect('/unknown_route');

      // assert
      expect(result, isNotNull);
      expect(result!.name, equals(AppRouter.home.name));
    });
  });

  group('AuthMiddleware - Com sessão e usuário não-admin', () {
    test('deve redirecionar para home quando usuário não for admin', () {
      // arrange
      AppBinding.put<SessionEntity>(sessionEntity);
      AppBinding.put<UserEntity>(userEntity);

      // act
      final result = authMiddleware.redirect('/admin');

      // assert
      expect(result, isNotNull);
      expect(result!.name, equals(AppRouter.home.name));
    });

    test('deve retornar null quando já estiver na rota home', () {
      // arrange
      AppBinding.put<SessionEntity>(sessionEntity);
      AppBinding.put<UserEntity>(userEntity);

      // act
      final result = authMiddleware.redirect(AppRouter.home.name);

      // assert
      expect(result, isNull);
    });

    test('deve retornar null para rota home quando já estiver em home', () {
      // arrange
      AppBinding.put<SessionEntity>(sessionEntity);
      AppBinding.put<UserEntity>(userEntity);

      // act
      final result = authMiddleware.redirect('/home');

      // assert
      expect(result, isNull);
    });
  });

  group('AuthMiddleware - Com sessão e usuário admin', () {
    late UserEntity adminUser;

    setUp(() {
      adminUser = UserEntity(
        id: 'admin_id_123',
        username: 'adminuser',
        name: 'Admin User',
        email: 'admin@example.com',
        avatarUrl: 'https://example.com/admin_avatar.png',
        createdAt: '2024-01-01T00:00:00Z',
        updatedAt: '2024-01-01T00:00:00Z',
        permissions: [UserPermissionsEnum.ADMIN],
        locale: 'en',
        sessionToken: 'test_token_123',
        pushTopics: <String>[],
      );
    });

    test('deve redirecionar para admin quando usuário for admin', () {
      // arrange
      AppBinding.put<SessionEntity>(sessionEntity);
      AppBinding.put<UserEntity>(adminUser);

      // act
      final result = authMiddleware.redirect('/home');

      // assert
      expect(result, isNotNull);
      expect(result!.name, equals(AppRouter.admin.name));
    });

    test('deve retornar null quando já estiver na rota admin', () {
      // arrange
      AppBinding.put<SessionEntity>(sessionEntity);
      AppBinding.put<UserEntity>(adminUser);

      // act
      final result = authMiddleware.redirect(AppRouter.admin.name);

      // assert
      expect(result, isNull);
    });

    test('deve retornar null para rota admin quando já estiver em admin', () {
      // arrange
      AppBinding.put<SessionEntity>(sessionEntity);
      AppBinding.put<UserEntity>(adminUser);

      // act
      final result = authMiddleware.redirect('/admin');

      // assert
      expect(result, isNull);
    });
  });

  group('AuthMiddleware - Caminho feliz', () {
    test('deve retornar null quando usuário não-admin está em rota home', () {
      // arrange
      AppBinding.put<SessionEntity>(sessionEntity);
      AppBinding.put<UserEntity>(userEntity);

      // act
      final result = authMiddleware.redirect(AppRouter.home.name);

      // assert
      expect(result, isNull);
    });

    test('deve retornar null quando usuário admin está em rota admin', () {
      // arrange
      final adminUser = UserEntity(
        id: 'admin_id_123',
        username: 'adminuser',
        name: 'Admin User',
        email: 'admin@example.com',
        avatarUrl: 'https://example.com/admin_avatar.png',
        createdAt: '2024-01-01T00:00:00Z',
        updatedAt: '2024-01-01T00:00:00Z',
        permissions: [UserPermissionsEnum.ADMIN],
        locale: 'en',
        sessionToken: 'test_token_123',
        pushTopics: <String>[],
      );

      AppBinding.put<SessionEntity>(sessionEntity);
      AppBinding.put<UserEntity>(adminUser);

      // act
      final result = authMiddleware.redirect(AppRouter.admin.name);

      // assert
      expect(result, isNull);
    });

    test(
      'deve redirecionar para home quando usuário não-admin e route é null',
      () {
        // arrange
        AppBinding.put<SessionEntity>(sessionEntity);
        AppBinding.put<UserEntity>(userEntity);

        // act
        // Quando route é null e usuário não é admin, redireciona para home
        final result = authMiddleware.redirect(null);

        // assert
        expect(result, isNotNull);
        expect(result!.name, equals(AppRouter.home.name));
      },
    );
  });

  group('AuthMiddleware - Cenários edge', () {
    test(
      'deve redirecionar para home quando sessão e usuário existem mas rota é nula',
      () {
        // arrange
        AppBinding.put<SessionEntity>(sessionEntity);
        AppBinding.put<UserEntity>(userEntity);

        // act
        // Quando route é null e usuário não é admin, redireciona para home
        final result = authMiddleware.redirect(null);

        // assert
        expect(result, isNotNull);
        expect(result!.name, equals(AppRouter.home.name));
      },
    );

    test(
      'deve redirecionar para home quando sessão existe e rota não é login (rota login não configurada)',
      () {
        // arrange
        AppBinding.put<SessionEntity>(sessionEntity);
        // Usuário não está registrado

        // act
        // Como AppRoutes.findByRoute retorna null no ambiente de teste,
        // o middleware redireciona para home ao invés de login
        final result = authMiddleware.redirect('/settings');

        // assert
        expect(result, isNotNull);
        expect(result!.name, equals(AppRouter.home.name));
      },
    );

    test('deve manter usuário com múltiplas permissões incluindo admin', () {
      // arrange
      final multiPermissionUser = UserEntity(
        id: 'user_id_123',
        username: 'testuser',
        name: 'Test User',
        email: 'test@example.com',
        avatarUrl: 'https://example.com/avatar.png',
        createdAt: '2024-01-01T00:00:00Z',
        updatedAt: '2024-01-01T00:00:00Z',
        permissions: [UserPermissionsEnum.USER, UserPermissionsEnum.ADMIN],
        locale: 'en',
        sessionToken: 'test_token_123',
        pushTopics: <String>[],
      );

      AppBinding.put<SessionEntity>(sessionEntity);
      AppBinding.put<UserEntity>(multiPermissionUser);

      // act
      final result = authMiddleware.redirect(AppRouter.home.name);

      // assert
      expect(result, isNotNull);
      expect(result!.name, equals(AppRouter.admin.name));
    });

    test(
      'deve redirecionar para home quando sessão existe mas usuário não tem permissão admin',
      () {
        // arrange
        AppBinding.put<SessionEntity>(sessionEntity);
        AppBinding.put<UserEntity>(userEntity);

        // act
        final result = authMiddleware.redirect(AppRouter.admin.name);

        // assert
        expect(result, isNotNull);
        expect(result!.name, equals(AppRouter.home.name));
      },
    );
  });
}
