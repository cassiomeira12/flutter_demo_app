import 'package:admin/src/domain/domain.dart';
import 'package:admin/src/presentation/users/users.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGetAllUsersUseCase extends Mock implements GetAllUsersUseCase {}

// Stub para UsersStore
class StubUsersStore extends UsersStore {}

void main() {
  late MockGetAllUsersUseCase mockGetAllUsersUseCase;
  late StubUsersStore stubUsersStore;
  late UsersController controller;
  late UserEntity userEntity;

  setUpAll(() {
    registerFallbackValue(
      UserEntity(
        id: 'fallback_id',
        username: 'fallback_user',
        name: 'Fallback User',
        email: 'fallback@example.com',
        avatarUrl: 'https://example.com/avatar.png',
        createdAt: '2024-01-01',
        updatedAt: '2024-01-01',
        permissions: [UserPermissionsEnum.USER],
        locale: 'en',
        sessionToken: 'fallback_token',
        pushTopics: [],
      ),
    );
  });

  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true;
  });

  setUp(() {
    mockGetAllUsersUseCase = MockGetAllUsersUseCase();
    stubUsersStore = StubUsersStore();

    userEntity = UserEntity(
      id: 'test_id',
      username: 'test_user',
      name: 'Test User',
      email: 'test@example.com',
      avatarUrl: 'https://example.com/avatar.png',
      createdAt: '2024-01-01',
      updatedAt: '2024-01-01',
      permissions: [UserPermissionsEnum.USER],
      locale: 'en',
      sessionToken: 'test_token',
      pushTopics: [],
    );

    controller = UsersController(
      getAllUsersUseCase: mockGetAllUsersUseCase,
      usersStore: stubUsersStore,
    );
  });

  group('UsersController', () {
    group('getAllUsers', () {
      test(
        'deve retornar lista de usuarios quando chamada com sucesso',
        () async {
          // arrange
          final users = [
            UserEntity(
              id: 'user_1',
              username: 'user_one',
              name: 'User One',
              email: 'user1@example.com',
              avatarUrl: 'https://example.com/avatar1.png',
              createdAt: '2024-01-01',
              updatedAt: '2024-01-01',
              permissions: [UserPermissionsEnum.USER],
              locale: 'en',
              sessionToken: 'token_1',
              pushTopics: [],
            ),
            UserEntity(
              id: 'user_2',
              username: 'user_two',
              name: 'User Two',
              email: 'user2@example.com',
              avatarUrl: 'https://example.com/avatar2.png',
              createdAt: '2024-01-01',
              updatedAt: '2024-01-01',
              permissions: [UserPermissionsEnum.USER],
              locale: 'en',
              sessionToken: 'token_2',
              pushTopics: [],
            ),
          ];

          when(
            () => mockGetAllUsersUseCase.call(any()),
          ).thenAnswer((_) async => users);

          // act
          await controller.getAllUsers();

          // assert
          expect(controller.users, users);
          expect(controller.users.length, 2);
          expect(controller.isLoading.value, false);
          expect(controller.errorMessage.value, isEmpty);
          verify(() => mockGetAllUsersUseCase.call(any())).called(1);
        },
      );

      test(
        'deve definir erro quando use case lancahar BaseException',
        () async {
          // arrange
          final baseException = BaseException(
            message: 'Erro ao buscar usuarios',
          );

          when(
            () => mockGetAllUsersUseCase.call(any()),
          ).thenThrow(baseException);

          // act
          await controller.getAllUsers();

          // assert
          expect(controller.users, isEmpty);
          expect(controller.isLoading.value, false);
          expect(controller.errorMessage.value, isNotEmpty);
        },
      );

      test(
        'deve definir erro quando use case lancahar Exception generica',
        () async {
          // arrange
          when(
            () => mockGetAllUsersUseCase.call(any()),
          ).thenThrow(Exception('Erro generico'));

          // act
          await controller.getAllUsers();

          // assert
          expect(controller.users, isEmpty);
          expect(controller.isLoading.value, false);
          expect(controller.errorMessage.value, isNotEmpty);
        },
      );

      test('deve definir isLoading como true durante execucao', () async {
        // arrange
        when(() => mockGetAllUsersUseCase.call(any())).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return <UserEntity>[];
        });

        // act
        final future = controller.getAllUsers();

        // assert - durante execucao
        expect(controller.isLoading.value, true);

        // wait for completion
        await future;
        expect(controller.isLoading.value, false);
      });
    });

    group('openUserDetails', () {
      test('deve definir usuario selecionado e navegar para detalhes', () {
        // arrange & act
        controller.openUserDetails(userEntity);

        // assert
        expect(stubUsersStore.userSelected, same(userEntity));
        expect(stubUsersStore.userSelected!.id, 'test_id');
      });
    });

    group('onPopMenuSelected', () {
      test(
        'deve navegar para push notifications quando menu for send_push',
        () {
          // arrange
          const menu = 'send_push';

          // act
          controller.onPopMenuSelected(userEntity, menu);

          // assert
          expect(stubUsersStore.userSelected, same(userEntity));
          expect(stubUsersStore.userSelected!.username, 'test_user');
        },
      );

      test('deve navegar para push notifications com usuario correto', () {
        // arrange
        const menu = 'send_push';

        final anotherUser = UserEntity(
          id: 'another_id',
          username: 'another_user',
          name: 'Another User',
          email: 'another@example.com',
          avatarUrl: 'https://example.com/another.png',
          createdAt: '2024-01-01',
          updatedAt: '2024-01-01',
          permissions: [UserPermissionsEnum.USER],
          locale: 'en',
          sessionToken: 'another_token',
          pushTopics: [],
        );

        // act
        controller.onPopMenuSelected(anotherUser, menu);

        // assert
        expect(stubUsersStore.userSelected, same(anotherUser));
        expect(stubUsersStore.userSelected!.id, 'another_id');
      });

      test('deve navegar para push notifications com menu invalido', () {
        // arrange
        const menu = 'invalid_menu';

        // act
        controller.onPopMenuSelected(userEntity, menu);

        // assert - deve manter usuario selecionado como null para menu invalido
        expect(stubUsersStore.userSelected, isNull);
      });
    });

    group('pageRouteNamed', () {
      test('deve retornar rota correta', () {
        // arrange & act
        final result = controller.pageRouteNamed;

        // assert
        expect(result, '/users');
      });
    });

    group('users', () {
      test('deve iniciar vazio', () {
        // arrange & act
        final result = controller.users;

        // assert
        expect(result, isEmpty);
      });
    });

    group('isLoading', () {
      test('deve iniciar como true', () {
        // arrange & act
        final result = controller.isLoading.value;

        // assert
        expect(result, true);
      });
    });

    group('errorMessage', () {
      test('deve iniciar vazio', () {
        // arrange & act
        final result = controller.errorMessage.value;

        // assert
        expect(result, isEmpty);
      });
    });
  });
}
