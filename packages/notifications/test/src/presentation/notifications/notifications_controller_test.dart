import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notifications/src/domain/domain.dart';
import 'package:notifications/src/presentation/notifications/notifications_controller.dart';

class MockListUserNotificationsUseCase extends Mock
    implements ListUserNotificationsUseCase {}

class MockReadNotificationUseCase extends Mock
    implements ReadNotificationUseCase {}

class FakeNotificationEntity extends Fake implements NotificationEntity {}

class FakeBaseException extends Fake implements BaseException {}

void main() {
  late MockListUserNotificationsUseCase mockListUserNotificationsUseCase;
  late MockReadNotificationUseCase mockReadNotificationUseCase;
  late NotificationsController notificationsController;

  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
    AppBinding.testMode(true);
    registerFallbackValue(FakeNotificationEntity());
    registerFallbackValue(FakeBaseException());
  });

  setUp(() {
    mockListUserNotificationsUseCase = MockListUserNotificationsUseCase();
    mockReadNotificationUseCase = MockReadNotificationUseCase();

    notificationsController = NotificationsController(
      listUserNotifications: mockListUserNotificationsUseCase,
      readNotificationUseCase: mockReadNotificationUseCase,
    );
  });

  tearDown(() {
    AppBinding.reset();
  });

  group('NotificationsController', () {
    group('Sucesso - getAllNotifications', () {
      test(
        'deve retornar lista de notificacoes quando a busca for bem-sucedida',
        () async {
          // arrange
          final notifications = [
            NotificationEntity(
              objectId: 'notif-1',
              title: 'Notification 1',
              body: 'Body 1',
              viewed: false,
              imageUrl: 'https://example.com/image1.png',
            ),
            NotificationEntity(
              objectId: 'notif-2',
              title: 'Notification 2',
              body: 'Body 2',
              viewed: true,
              imageUrl: null,
            ),
          ];

          when(
            () => mockListUserNotificationsUseCase.call(any()),
          ).thenAnswer((_) async => notifications);

          // act
          await notificationsController.getAllNotifications();

          // assert
          expect(notificationsController.notifications.length, 2);
          expect(notificationsController.notifications[0].objectId, 'notif-1');
          expect(
            notificationsController.notifications[0].title,
            'Notification 1',
          );
          expect(notificationsController.isLoading.value, false);
          expect(notificationsController.errorMessage.value, '');
          verify(() => mockListUserNotificationsUseCase.call(0)).called(1);
        },
      );

      test(
        'deve retornar lista vazia quando nao houver notificacoes',
        () async {
          // arrange
          when(
            () => mockListUserNotificationsUseCase.call(any()),
          ).thenAnswer((_) async => <NotificationEntity>[]);

          // act
          await notificationsController.getAllNotifications();

          // assert
          expect(notificationsController.notifications, isEmpty);
          expect(notificationsController.isLoading.value, false);
          verify(() => mockListUserNotificationsUseCase.call(0)).called(1);
        },
      );
    });

    group('Erro - getAllNotifications', () {
      test(
        'deve tratar BaseException e definir mensagem de erro',
        () async {
          // arrange
          final baseException = BaseException(
            message: 'Failed to load notifications',
            complement: 'LOAD_ERROR',
          );

          when(
            () => mockListUserNotificationsUseCase.call(any()),
          ).thenThrow(baseException);

          // act
          await notificationsController.getAllNotifications();

          // assert
          expect(notificationsController.notifications, isEmpty);
          expect(notificationsController.isLoading.value, false);
          expect(notificationsController.errorMessage.value, isNotEmpty);
        },
      );

      test(
        'deve tratar excecao generica e definir mensagem de erro',
        () async {
          // arrange
          when(
            () => mockListUserNotificationsUseCase.call(any()),
          ).thenThrow(Exception('Unknown error'));

          // act
          await notificationsController.getAllNotifications();

          // assert
          expect(notificationsController.notifications, isEmpty);
          expect(notificationsController.isLoading.value, false);
          expect(notificationsController.errorMessage.value, isNotEmpty);
        },
      );
    });

    group('Sucesso - readNotification', () {
      test(
        'deve marcar notificacao como lida e atualizar lista',
        () async {
          // arrange
          final notification = NotificationEntity(
            objectId: 'notif-1',
            title: 'Notification 1',
            body: 'Body 1',
            viewed: false,
            imageUrl: null,
          );

          final updatedNotifications = [
            NotificationEntity(
              objectId: 'notif-1',
              title: 'Notification 1',
              body: 'Body 1',
              viewed: true,
              imageUrl: null,
            ),
          ];

          when(
            () => mockReadNotificationUseCase.call(any()),
          ).thenAnswer((_) async {});
          when(
            () => mockListUserNotificationsUseCase.call(any()),
          ).thenAnswer((_) async => updatedNotifications);

          // act
          await notificationsController.readNotification(notification);

          // assert
          verify(
            () => mockReadNotificationUseCase.call(notification),
          ).called(1);
          verify(() => mockListUserNotificationsUseCase.call(0)).called(1);
        },
      );

      test(
        'deve ignorar quando a notificacao ja foi visualizada',
        () async {
          // arrange
          final notification = NotificationEntity(
            objectId: 'notif-1',
            title: 'Notification 1',
            body: 'Body 1',
            viewed: true,
            imageUrl: null,
          );

          // act
          await notificationsController.readNotification(notification);

          // assert
          verifyNever(() => mockReadNotificationUseCase.call(any()));
          verifyNever(() => mockListUserNotificationsUseCase.call(any()));
        },
      );
    });

    group('Erro - readNotification', () {
      test(
        'deve propagar excecao quando falhar ao ler notificacao',
        () async {
          // arrange
          final notification = NotificationEntity(
            objectId: 'notif-1',
            title: 'Notification 1',
            body: 'Body 1',
            viewed: false,
            imageUrl: null,
          );

          when(
            () => mockReadNotificationUseCase.call(any()),
          ).thenThrow(Exception('Failed to read'));

          // act & assert
          expect(
            () => notificationsController.readNotification(notification),
            throwsException,
          );
        },
      );
    });

    group('Sucesso - refreshNotifications', () {
      test(
        'deve atualizar a lista de notificacoes',
        () async {
          // arrange
          final notifications = [
            NotificationEntity(
              objectId: 'notif-refresh',
              title: 'Refreshed Notification',
              body: 'Body',
              viewed: false,
              imageUrl: null,
            ),
          ];

          when(
            () => mockListUserNotificationsUseCase.call(any()),
          ).thenAnswer((_) async => notifications);

          // act
          notificationsController.refreshNotifications();

          // assert
          // refreshNotifications e refreshUnCountNotifications sao void
          // verificar que o metodo foi chamado
          verify(() => mockListUserNotificationsUseCase.call(0)).called(1);
        },
      );
    });

    group('Sucesso - Estados Iniciais', () {
      test(
        'deve iniciar com lista vazia e loading true',
        () {
          // assert
          expect(notificationsController.notifications, isEmpty);
          expect(notificationsController.isLoading.value, true);
          expect(notificationsController.errorMessage.value, '');
        },
      );

      test(
        'deve chamar getAllNotifications no onReady',
        () async {
          // arrange
          final notifications = <NotificationEntity>[];
          when(
            () => mockListUserNotificationsUseCase.call(any()),
          ).thenAnswer((_) async => notifications);

          // act
          notificationsController.onReady();

          // assert
          verify(() => mockListUserNotificationsUseCase.call(0)).called(1);
        },
      );
    });

    group('Erro - Estados', () {
      test(
        'deve definir isLoading como false apos erro',
        () async {
          // arrange
          when(
            () => mockListUserNotificationsUseCase.call(any()),
          ).thenThrow(Exception('Error'));

          // act
          await notificationsController.getAllNotifications();

          // assert
          expect(notificationsController.isLoading.value, false);
        },
      );

      test(
        'deve manter errorMessage vazio em caso de sucesso',
        () async {
          // arrange
          when(
            () => mockListUserNotificationsUseCase.call(any()),
          ).thenAnswer((_) async => <NotificationEntity>[]);

          // act
          await notificationsController.getAllNotifications();

          // assert
          expect(notificationsController.errorMessage.value, '');
        },
      );
    });
  });
}
