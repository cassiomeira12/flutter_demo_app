import 'package:admin/src/domain/domain.dart';
import 'package:admin/src/presentation/create_notification/create_notification_controller.dart';
import 'package:admin/src/presentation/users/users.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGetAllUsersUseCase extends Mock implements GetAllUsersUseCase {}

class MockCreateNotificationUseCase extends Mock
    implements CreateNotificationUseCase {}

class MockTestPushNotificationUseCase extends Mock
    implements TestPushNotificationUseCase {}

// Stub para UsersStore
class StubUsersStore extends UsersStore {}

void main() {
  late MockGetAllUsersUseCase mockGetAllUsersUseCase;
  late MockCreateNotificationUseCase mockCreateNotificationUseCase;
  late MockTestPushNotificationUseCase mockTestPushNotificationUseCase;
  late StubUsersStore stubUsersStore;
  late CreateNotificationController controller;
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
    registerFallbackValue(
      TestPushNotificationDto(
        title: 'fallback',
        body: 'fallback',
      ),
    );
  });

  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
    AppBinding.testMode(true);
  });

  setUp(() {
    mockGetAllUsersUseCase = MockGetAllUsersUseCase();
    mockCreateNotificationUseCase = MockCreateNotificationUseCase();
    mockTestPushNotificationUseCase = MockTestPushNotificationUseCase();
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

    stubUsersStore.userSelected = userEntity;

    // Register dependencies before creating controller
    AppBinding.put<UserEntity>(userEntity);
    AppBinding.put<UsersStore>(stubUsersStore);

    controller = CreateNotificationController(
      getAllUsersUseCase: mockGetAllUsersUseCase,
      createNotificationUseCase: mockCreateNotificationUseCase,
      testPushNotificationUseCase: mockTestPushNotificationUseCase,
    );
  });

  group('CreateNotificationController', () {
    group('searchUsers', () {
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
          final result = await controller.searchUsers('test', 10, 0);

          // assert
          expect(result, users);
          expect(result.length, 2);
          verify(() => mockGetAllUsersUseCase.call(any())).called(1);
        },
      );

      test('deve lanar excecao quando uso caso falhar', () async {
        // arrange
        when(
          () => mockGetAllUsersUseCase.call(any()),
        ).thenThrow(Exception('Erro ao buscar usuarios'));

        // act & assert
        expect(
          () => controller.searchUsers('test', 10, 0),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('titleValidator', () {
      test('deve retornar null quando titulo for valido', () {
        // arrange
        const validTitle = 'Test Title';

        // act
        final result = controller.titleValidator(validTitle);

        // assert
        expect(result, isNull);
      });

      test('deve retornar mensagem de erro quando titulo for vazio', () {
        // arrange
        const emptyTitle = '';

        // act
        final result = controller.titleValidator(emptyTitle);

        // assert
        expect(result, isNotNull);
        expect(result, contains('push_title_input_empty_error'));
      });

      test(
        'deve retornar mensagem de erro quando titulo for espaco em branco',
        () {
          // arrange
          const whitespaceTitle = '   ';

          // act
          final result = controller.titleValidator(whitespaceTitle);

          // assert
          expect(result, isNotNull);
          expect(result, contains('push_title_input_empty_error'));
        },
      );

      test('deve retornar null quando titulo for nulo', () {
        // arrange
        const String? nullTitle = null;

        // act
        final result = controller.titleValidator(nullTitle);

        // assert
        expect(result, isNotNull);
        expect(result, contains('push_title_input_empty_error'));
      });
    });

    group('bodyValidator', () {
      test('deve retornar null quando corpo for valido', () {
        // arrange
        const validBody = 'Test body message';

        // act
        final result = controller.bodyValidator(validBody);

        // assert
        expect(result, isNull);
      });

      test('deve retornar mensagem de erro quando corpo for vazio', () {
        // arrange
        const emptyBody = '';

        // act
        final result = controller.bodyValidator(emptyBody);

        // assert
        expect(result, isNotNull);
        expect(result, contains('push_title_input_empty_error'));
      });

      test(
        'deve retornar mensagem de erro quando corpo for espaco em branco',
        () {
          // arrange
          const whitespaceBody = '   ';

          // act
          final result = controller.bodyValidator(whitespaceBody);

          // assert
          expect(result, isNotNull);
          expect(result, contains('push_title_input_empty_error'));
        },
      );

      test('deve retornar null quando corpo for nulo', () {
        // arrange
        const String? nullBody = null;

        // act
        final result = controller.bodyValidator(nullBody);

        // assert
        expect(result, isNotNull);
        expect(result, contains('push_title_input_empty_error'));
      });
    });

    group('createNotification', () {
      test('deve criar notificação com sucesso', () async {
        // arrange
        when(
          () => mockCreateNotificationUseCase.call(
            title: any(named: 'title'),
            body: any(named: 'body'),
            imageUrl: any(named: 'imageUrl'),
            user: any(named: 'user'),
          ),
        ).thenAnswer((_) async {});

        // act
        await controller.createNotification(
          title: 'Test Title',
          body: 'Test Body',
          imageUrl: 'https://example.com/image.png',
          user: userEntity,
        );

        // assert
        verify(
          () => mockCreateNotificationUseCase.call(
            title: 'Test Title',
            body: 'Test Body',
            imageUrl: 'https://example.com/image.png',
            user: userEntity,
          ),
        ).called(1);
      });

      test('deve lanar excecao quando uso caso falhar', () async {
        // arrange
        when(
          () => mockCreateNotificationUseCase.call(
            title: any(named: 'title'),
            body: any(named: 'body'),
            imageUrl: any(named: 'imageUrl'),
            user: any(named: 'user'),
          ),
        ).thenThrow(Exception('Erro ao criar notificacao'));

        // act & assert
        expect(
          () => controller.createNotification(
            title: 'Test Title',
            body: 'Test Body',
            imageUrl: 'https://example.com/image.png',
            user: userEntity,
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('testPush', () {
      test('deve retornar sucesso quando envio for bem sucessido', () async {
        // arrange
        when(
          () => mockTestPushNotificationUseCase.call(any()),
        ).thenAnswer((_) async => const Success<void>());

        // act
        final result = await controller.testPush(
          title: 'Test Title',
          body: 'Test Body',
          imageUrl: 'https://example.com/image.png',
        );

        // assert
        expect(result, isA<Success<void>>());
        verify(() => mockTestPushNotificationUseCase.call(any())).called(1);
      });

      test('deve retornar erro quando envio falhar', () async {
        // arrange
        final exception = BaseException(
          message: 'Erro ao enviar push notification',
        );

        when(
          () => mockTestPushNotificationUseCase.call(any()),
        ).thenAnswer((_) async => Error<void>(exception));

        // act
        final result = await controller.testPush(
          title: 'Test Title',
          body: 'Test Body',
          imageUrl: 'https://example.com/image.png',
        );

        // assert
        expect(result, isA<Error<void>>());
      });
    });

    group('userSelected', () {
      test('deve retornar usuario selecionado da store injetada', () {
        // arrange & act
        final result = controller.userSelected;

        // assert
        expect(result, isA<UserEntity>());
        expect(result!.id, 'test_id');
        expect(result.username, 'test_user');
      });
    });

    group('onInit', () {
      test(
        'deve inicializar userController com nome do usuario selecionado',
        () {
          // arrange & act
          controller.onInit();

          // assert
          expect(controller.userController.text, 'test_user');
        },
      );
    });
  });
}
