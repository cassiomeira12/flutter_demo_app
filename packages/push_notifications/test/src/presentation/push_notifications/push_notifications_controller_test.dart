import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_notifications/src/presentation/push_notifications/push_notifications_controller.dart';

class MockCreateNotificationUseCase extends Mock
    implements CreateNotificationUseCase {}

class MockTestPushNotificationUseCase extends Mock
    implements TestPushNotificationUseCase {}

class FakeTestPushNotificationDto extends Fake
    implements TestPushNotificationDto {}

class FakeUserEntity extends Fake implements UserEntity {}

void main() {
  late MockCreateNotificationUseCase mockCreateNotificationUseCase;
  late MockTestPushNotificationUseCase mockTestPushNotificationUseCase;
  late PushNotificationsController pushNotificationsController;
  late UserEntity userEntity;

  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
    AppBinding.testMode(true);
    registerFallbackValue(FakeTestPushNotificationDto());
    registerFallbackValue(FakeUserEntity());
  });

  setUp(() {
    mockCreateNotificationUseCase = MockCreateNotificationUseCase();
    mockTestPushNotificationUseCase = MockTestPushNotificationUseCase();

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
      phoneNumber: '+5577999999999',
      phoneVerified: true,
      sosConfig: SosConfigEntity(onlyPolice: false, onlySafetyContacts: true),
    );

    AppBinding.put<UserEntity>(userEntity);

    pushNotificationsController = PushNotificationsController(
      createNotificationUseCase: mockCreateNotificationUseCase,
      testPushNotificationUseCase: mockTestPushNotificationUseCase,
    );
  });

  tearDown(() {
    AppBinding.delete<UserEntity>(force: true);
    AppBinding.reset();
  });

  group('PushNotificationsController', () {
    group('pageRouteNamed', () {
      test('deve retornar o nome correto da rota', () {
        expect(
          pushNotificationsController.pageRouteNamed,
          AppRouter.pushNotifications.name,
        );
      });
    });

    group('user', () {
      test('deve ter acesso ao usuario atual', () {
        expect(pushNotificationsController.user, isA<UserEntity>());
        expect(pushNotificationsController.user.id, 'test_id');
      });
    });

    group('Controllers', () {
      test('deve ter titleController inicializado', () {
        expect(
          pushNotificationsController.titleController,
          isA<TextEditingController>(),
        );
      });

      test('deve ter bodyController inicializado', () {
        expect(
          pushNotificationsController.bodyController,
          isA<TextEditingController>(),
        );
      });

      test('deve ter imageController inicializado', () {
        expect(
          pushNotificationsController.imageController,
          isA<TextEditingController>(),
        );
      });

      test('deve ter userController inicializado', () {
        expect(
          pushNotificationsController.userController,
          isA<TextEditingController>(),
        );
      });
    });

    group('titleValidator', () {
      test('deve retornar mensagem de erro quando titulo estiver vazio', () {
        expect(pushNotificationsController.titleValidator(''), isNotNull);
      });

      test('deve retornar mensagem de erro quando titulo for nulo', () {
        expect(pushNotificationsController.titleValidator(null), isNotNull);
      });

      test(
        'deve retornar mensagem de erro quando titulo tiver apenas espacos',
        () {
          expect(pushNotificationsController.titleValidator('   '), isNotNull);
        },
      );

      test('deve retornar null quando titulo for valido', () {
        expect(
          pushNotificationsController.titleValidator('Titulo valido'),
          isNull,
        );
      });
    });

    group('bodyValidator', () {
      test('deve retornar mensagem de erro quando corpo estiver vazio', () {
        expect(pushNotificationsController.bodyValidator(''), isNotNull);
      });

      test('deve retornar mensagem de erro quando corpo for nulo', () {
        expect(pushNotificationsController.bodyValidator(null), isNotNull);
      });

      test(
        'deve retornar mensagem de erro quando corpo tiver apenas espacos',
        () {
          expect(pushNotificationsController.bodyValidator('   '), isNotNull);
        },
      );

      test('deve retornar null quando corpo for valido', () {
        expect(
          pushNotificationsController.bodyValidator('Corpo valido'),
          isNull,
        );
      });
    });

    group('createNotification - Sucesso', () {
      test('deve criar notificacao com sucesso', () async {
        when(
          () => mockCreateNotificationUseCase.call(
            title: any(named: 'title'),
            body: any(named: 'body'),
            imageUrl: any(named: 'imageUrl'),
            user: any(named: 'user'),
          ),
        ).thenAnswer((_) async {});

        await pushNotificationsController.createNotification(
          title: 'Titulo Teste',
          body: 'Corpo Teste',
          imageUrl: 'https://example.com/image.png',
          user: userEntity,
        );

        verify(
          () => mockCreateNotificationUseCase.call(
            title: 'Titulo Teste',
            body: 'Corpo Teste',
            imageUrl: 'https://example.com/image.png',
            user: userEntity,
          ),
        ).called(1);
      });

      test('deve criar notificacao sem imageUrl', () async {
        when(
          () => mockCreateNotificationUseCase.call(
            title: any(named: 'title'),
            body: any(named: 'body'),
            imageUrl: any(named: 'imageUrl'),
            user: any(named: 'user'),
          ),
        ).thenAnswer((_) async {});

        await pushNotificationsController.createNotification(
          title: 'Titulo Teste',
          body: 'Corpo Teste',
          user: userEntity,
        );

        verify(
          () => mockCreateNotificationUseCase.call(
            title: 'Titulo Teste',
            body: 'Corpo Teste',
            imageUrl: null,
            user: userEntity,
          ),
        ).called(1);
      });
    });

    group('createNotification - Erro', () {
      test('deve lancar exception quando falhar', () async {
        when(
          () => mockCreateNotificationUseCase.call(
            title: any(named: 'title'),
            body: any(named: 'body'),
            imageUrl: any(named: 'imageUrl'),
            user: any(named: 'user'),
          ),
        ).thenThrow(Exception('Erro ao criar notificacao'));

        expect(
          () => pushNotificationsController.createNotification(
            title: 'Titulo Teste',
            body: 'Corpo Teste',
            user: userEntity,
          ),
          throwsException,
        );
      });

      test('deve lancar BaseException quando falhar', () async {
        final baseException = BaseException(
          message: 'Erro ao criar notificacao',
          complement: 'CREATE_NOTIFICATION_ERROR',
        );

        when(
          () => mockCreateNotificationUseCase.call(
            title: any(named: 'title'),
            body: any(named: 'body'),
            imageUrl: any(named: 'imageUrl'),
            user: any(named: 'user'),
          ),
        ).thenThrow(baseException);

        expect(
          () => pushNotificationsController.createNotification(
            title: 'Titulo Teste',
            body: 'Corpo Teste',
            user: userEntity,
          ),
          throwsA(isA<BaseException>()),
        );
      });
    });

    group('testPush - Sucesso', () {
      test(
        'deve retornar Success quando push for enviado com sucesso',
        () async {
          when(
            () => mockTestPushNotificationUseCase.call(any()),
          ).thenAnswer((_) async => const Success<void>());

          final result = await pushNotificationsController.testPush(
            title: 'Titulo Teste',
            body: 'Corpo Teste',
          );

          expect(result, isA<Success<void>>());
          verify(() => mockTestPushNotificationUseCase.call(any())).called(1);
        },
      );

      test('deve retornar Success com imageUrl quando fornecido', () async {
        when(
          () => mockTestPushNotificationUseCase.call(any()),
        ).thenAnswer((_) async => const Success<void>());

        final result = await pushNotificationsController.testPush(
          title: 'Titulo Teste',
          body: 'Corpo Teste',
          imageUrl: 'https://example.com/image.png',
        );

        expect(result, isA<Success<void>>());
        verify(() => mockTestPushNotificationUseCase.call(any())).called(1);
      });
    });

    group('testPush - Erro', () {
      test('deve retornar Error quando falhar', () async {
        final baseException = BaseException(
          message: 'Erro ao enviar push',
          complement: 'TEST_PUSH_ERROR',
        );

        when(
          () => mockTestPushNotificationUseCase.call(any()),
        ).thenAnswer((_) async => Error<void>(baseException));

        final result = await pushNotificationsController.testPush(
          title: 'Titulo Teste',
          body: 'Corpo Teste',
        );

        expect(result, isA<Error<void>>());
        verify(() => mockTestPushNotificationUseCase.call(any())).called(1);
      });

      test('deve propagar exception quando lancada pelo useCase', () async {
        when(
          () => mockTestPushNotificationUseCase.call(any()),
        ).thenThrow(Exception('Erro desconhecido'));

        expect(
          () => pushNotificationsController.testPush(
            title: 'Titulo Teste',
            body: 'Corpo Teste',
          ),
          throwsException,
        );
      });

      test('deve propagar BaseException quando lancada pelo useCase', () async {
        final baseException = BaseException(
          message: 'Erro de rede',
          complement: 'NETWORK_ERROR',
        );

        when(
          () => mockTestPushNotificationUseCase.call(any()),
        ).thenThrow(baseException);

        expect(
          () => pushNotificationsController.testPush(
            title: 'Titulo Teste',
            body: 'Corpo Teste',
          ),
          throwsA(isA<BaseException>()),
        );
      });
    });

    group('searchUsers', () {
      test('deve retornar lista vazia', () async {
        final result = await pushNotificationsController.searchUsers(
          'test',
          10,
          0,
        );

        expect(result, isEmpty);
      });

      test('deve retornar lista vazia com parametros nulos', () async {
        final result = await pushNotificationsController.searchUsers(
          null,
          null,
          null,
        );

        expect(result, isEmpty);
      });
    });
  });
}
