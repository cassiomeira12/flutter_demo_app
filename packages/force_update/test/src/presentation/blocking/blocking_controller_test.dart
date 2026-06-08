import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:force_update/src/presentation/blocking/blocking_controller.dart';

class MockLocalStorageUseCase extends Mock implements LocalStorageUseCase {}

class MockCheckPermissionUseCase extends Mock
    implements CheckPermissionUseCase {}

class MockPushMessagingService extends Mock implements PushMessagingService {}

class FakeAppInfoEntity extends Fake implements AppInfoEntity {}

void main() {
  late MockLocalStorageUseCase mockLocalStorageUseCase;
  late MockCheckPermissionUseCase mockCheckPermissionUseCase;
  late MockPushMessagingService mockPushMessagingService;
  late BlockingController blockingController;

  late AppInfoEntity appInfo;

  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
    AppBinding.testMode(true);
    registerFallbackValue(FakeAppInfoEntity());
    registerFallbackValue(Permission.notification);
    registerFallbackValue(<String>[]);
  });

  setUp(() {
    mockLocalStorageUseCase = MockLocalStorageUseCase();
    mockCheckPermissionUseCase = MockCheckPermissionUseCase();
    mockPushMessagingService = MockPushMessagingService();

    appInfo = AppInfoEntity(
      appName: 'Test App',
      packageName: 'com.test.app',
      buildSignature: 'test-signature',
      installerStore: null,
      version: '1.0.0',
      build: '1',
    );

    blockingController = BlockingController(
      localStorageUseCase: mockLocalStorageUseCase,
      appInfoEntity: appInfo,
      checkPermissionUseCase: mockCheckPermissionUseCase,
      pushMessagingService: mockPushMessagingService,
    );
  });

  group('BlockingController', () {
    group('Sucesso', () {
      test('deve retornar pushSubscribed inicial como false', () {
        expect(blockingController.pushSubscribed.value, isFalse);
      });

      test(
        'deveSubscrevePushNotification deve definir pushSubscribed como true quando permissao granted e subscription bem-sucedida',
        () async {
          when(
            () => mockCheckPermissionUseCase.call(any()),
          ).thenAnswer((_) async => PermissionStatus.granted);

          when(
            () => mockLocalStorageUseCase.get<bool>(BLOCKED_APP),
          ).thenAnswer((_) async => null);

          when(
            () => mockPushMessagingService.subscribeTopic(any()),
          ).thenAnswer((_) async {});

          when(
            () => mockLocalStorageUseCase.set<bool>(any(), any()),
          ).thenAnswer((_) async => true);

          blockingController.onReady();

          await Future.delayed(const Duration(milliseconds: 100));

          verify(
            () => mockCheckPermissionUseCase.call(Permission.notification),
          ).called(1);
          verify(
            () => mockPushMessagingService.subscribeTopic(any()),
          ).called(1);
          verify(
            () => mockLocalStorageUseCase.set<bool>(BLOCKED_APP, true),
          ).called(1);
        },
      );

      test(
        'deve continuar quando permissao de notificacao ja foi negada anteriormente',
        () async {
          when(
            () => mockCheckPermissionUseCase.call(any()),
          ).thenAnswer((_) async => PermissionStatus.denied);

          blockingController.onReady();

          await Future.delayed(const Duration(milliseconds: 100));

          verify(
            () => mockCheckPermissionUseCase.call(Permission.notification),
          ).called(1);
          verifyNever(() => mockPushMessagingService.subscribeTopic(any()));
        },
      );

      test(
        'deve nao SubscrevePushNotification quando ja esta blockingApp',
        () async {
          when(
            () => mockCheckPermissionUseCase.call(any()),
          ).thenAnswer((_) async => PermissionStatus.granted);

          when(
            () => mockLocalStorageUseCase.get<bool>(BLOCKED_APP),
          ).thenAnswer((_) async => true);

          blockingController.onReady();

          await Future.delayed(const Duration(milliseconds: 100));

          verify(
            () => mockCheckPermissionUseCase.call(Permission.notification),
          ).called(1);
          verifyNever(() => mockPushMessagingService.subscribeTopic(any()));
          verifyNever(() => mockLocalStorageUseCase.set<bool>(any(), any()));
        },
      );

      test(
        'deve tentar subscription mesmo quando exception ocorre no checkPermission',
        () async {
          when(
            () => mockCheckPermissionUseCase.call(any()),
          ).thenThrow(Exception('Permission check failed'));

          when(
            () => mockLocalStorageUseCase.get<bool>(BLOCKED_APP),
          ).thenAnswer((_) async => null);

          when(
            () => mockPushMessagingService.subscribeTopic(any()),
          ).thenAnswer((_) async {});

          when(
            () => mockLocalStorageUseCase.set<bool>(any(), any()),
          ).thenAnswer((_) async => true);

          blockingController.onReady();

          await Future.delayed(const Duration(milliseconds: 100));

          verify(
            () => mockCheckPermissionUseCase.call(Permission.notification),
          ).called(1);
        },
      );

      test(
        'deve continuar quando exception ocorre no subscribeTopic',
        () async {
          when(
            () => mockCheckPermissionUseCase.call(any()),
          ).thenAnswer((_) async => PermissionStatus.granted);

          when(
            () => mockLocalStorageUseCase.get<bool>(BLOCKED_APP),
          ).thenAnswer((_) async => null);

          when(
            () => mockPushMessagingService.subscribeTopic(any()),
          ).thenThrow(Exception('Subscribe failed'));

          when(
            () => mockLocalStorageUseCase.set<bool>(any(), any()),
          ).thenAnswer((_) async => true);

          blockingController.onReady();

          await Future.delayed(const Duration(milliseconds: 100));

          verify(
            () => mockCheckPermissionUseCase.call(Permission.notification),
          ).called(1);
          verify(
            () => mockPushMessagingService.subscribeTopic(any()),
          ).called(1);
        },
      );
    });

    group('Erro', () {
      test(
        'deve tratar exception quando checkPermissionUseCase falha',
        () async {
          when(
            () => mockCheckPermissionUseCase.call(any()),
          ).thenThrow(Exception('Permission check failed'));

          when(
            () => mockLocalStorageUseCase.get<bool>(BLOCKED_APP),
          ).thenAnswer((_) async => null);

          when(
            () => mockPushMessagingService.subscribeTopic(any()),
          ).thenAnswer((_) async {});

          when(
            () => mockLocalStorageUseCase.set<bool>(any(), any()),
          ).thenAnswer((_) async => true);

          blockingController.onReady();

          await Future.delayed(const Duration(milliseconds: 100));

          verifyNever(() => mockPushMessagingService.subscribeTopic(any()));
        },
      );

      test(
        'deve tratar exception quando pushMessagingService.subscribeTopic falha',
        () async {
          when(
            () => mockCheckPermissionUseCase.call(any()),
          ).thenAnswer((_) async => PermissionStatus.granted);

          when(
            () => mockLocalStorageUseCase.get<bool>(BLOCKED_APP),
          ).thenAnswer((_) async => null);

          when(
            () => mockPushMessagingService.subscribeTopic(any()),
          ).thenThrow(Exception('Subscribe topic failed'));

          when(
            () => mockLocalStorageUseCase.set<bool>(any(), any()),
          ).thenAnswer((_) async => true);

          blockingController.onReady();

          await Future.delayed(const Duration(milliseconds: 100));

          verify(
            () => mockPushMessagingService.subscribeTopic(any()),
          ).called(1);
          verifyNever(
            () => mockLocalStorageUseCase.set<bool>(BLOCKED_APP, true),
          );
          expect(blockingController.pushSubscribed.value, isFalse);
        },
      );
    });
  });
}
