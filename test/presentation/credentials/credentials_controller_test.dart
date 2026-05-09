import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/domain/domain.dart';
import 'package:flutter_demo_app/presentation/credentials/credentials.dart';
import 'package:flutter_test/flutter_test.dart';

class MockCredentialsStore extends Mock implements CredentialsStore {}

class MockCredentialRepository extends Mock implements CredentialRepository {}

class MockListCredentialUseCase extends Mock implements ListCredentialUseCase {}

class MockUpdateCredentialUseCase extends Mock
    implements UpdateCredentialUseCase {}

class FakeCredentialEntity extends Fake implements CredentialEntity {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  late MockCredentialsStore mockCredentialsStore;
  late MockCredentialRepository mockCredentialRepository;
  late MockListCredentialUseCase mockListCredentialUseCase;
  late MockUpdateCredentialUseCase mockUpdateCredentialUseCase;
  late CredentialsController controller;

  setUpAll(() {
    registerFallbackValue(FakeCredentialEntity());
  });

  setUp(() {
    mockCredentialsStore = MockCredentialsStore();
    mockCredentialRepository = MockCredentialRepository();
    mockListCredentialUseCase = MockListCredentialUseCase();
    mockUpdateCredentialUseCase = MockUpdateCredentialUseCase();

    when(() => mockCredentialsStore.credential).thenReturn(
      Rxn<CredentialEntity>(),
    );

    when(() => mockCredentialRepository.valueListenable).thenReturn(
      ValueNotifier<List<ValueNotifier<CredentialEntity>>>([]),
    );

    controller = CredentialsController(
      credentialsStore: mockCredentialsStore,
      listCredentialUseCase: mockListCredentialUseCase,
      updateCredentialUseCase: mockUpdateCredentialUseCase,
      credentialRepository: mockCredentialRepository,
    );
  });

  group('CredentialsController', () {
    group('getAllCredentials', () {
      test(
        'deve retornar sucesso quando listCredentialUseCase.call() executar corretamente',
        () async {
          when(
            () => mockCredentialRepository.initLocalDatabase(),
          ).thenAnswer((_) async {});
          when(
            () => mockListCredentialUseCase.call(),
          ).thenAnswer((_) async => []);

          await controller.getAllCredentials();

          expect(controller.isLoading.value, false);
          expect(controller.errorMessage.value, '');
          verify(() => mockListCredentialUseCase.call()).called(1);
        },
      );

      test(
        'deve retornar erro quando listCredentialUseCase lanรงar BaseException',
        () async {
          when(
            () => mockCredentialRepository.initLocalDatabase(),
          ).thenAnswer((_) async {});
          when(() => mockListCredentialUseCase.call()).thenThrow(
            BaseException(message: 'Erro de teste', throwReport: false),
          );

          await controller.getAllCredentials();

          expect(controller.isLoading.value, false);
          expect(controller.errorMessage.value, 'Erro de teste');
        },
      );

      test(
        'deve retornar erro genรฉrico quando listCredentialUseCase lanรงar Exception',
        () async {
          when(
            () => mockCredentialRepository.initLocalDatabase(),
          ).thenAnswer((_) async {});
          when(() => mockListCredentialUseCase.call()).thenThrow(
            Exception('Erro genรฉrico'),
          );

          await controller.getAllCredentials();

          expect(controller.isLoading.value, false);
          expect(controller.errorMessage.value.contains('Exception'), true);
        },
      );
    });

    group('addCredential', () {
      test('deve chamar credentialsStore.credential.value = null', () async {
        final mockRxn = Rxn<CredentialEntity>();
        when(() => mockCredentialsStore.credential).thenReturn(mockRxn);

        await controller.addCredential();

        expect(mockRxn.value, null);
      });
    });

    group('openCredential', () {
      test(
        'deve definir credentialsStore.credential.value com o item passado',
        () async {
          final credential = CredentialEntity(
            objectId: '123',
            name: 'Test',
            userName: 'user',
            password: 'pass',
            secretKeyOTP: null,
            url: null,
            faviconUrl: null,
            notes: null,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          final mockRxn = Rxn<CredentialEntity>();
          when(() => mockCredentialsStore.credential).thenReturn(mockRxn);

          await controller.openCredential(credential);

          expect(mockRxn.value, credential);
        },
      );
    });

    group('errorFavIcon', () {
      test(
        'deve atualizar credencial com faviconUrl null quando executado com sucesso',
        () async {
          final credential = CredentialEntity(
            objectId: '123',
            name: 'Test',
            userName: 'user',
            password: 'pass',
            secretKeyOTP: null,
            url: 'http://test.com',
            faviconUrl: 'http://test.com/favicon.png',
            notes: null,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          final credentialWithoutFavicon = CredentialEntity(
            objectId: '123',
            name: 'Test',
            userName: 'user',
            password: 'pass',
            secretKeyOTP: null,
            url: 'http://test.com',
            faviconUrl: null,
            notes: null,
            createdAt: credential.createdAt,
            updatedAt: credential.updatedAt,
          );

          when(
            () => mockUpdateCredentialUseCase.call(any()),
          ).thenAnswer((_) async => credentialWithoutFavicon);

          await controller.errorFavIcon(credential);

          verify(() => mockUpdateCredentialUseCase.call(any())).called(1);
        },
      );

      test(
        'deve silenciosamente tratar erro quando updateCredentialUseCase lanรงar exceรงรฃo',
        () async {
          final credential = CredentialEntity(
            objectId: '123',
            name: 'Test',
            userName: 'user',
            password: 'pass',
            secretKeyOTP: null,
            url: 'http://test.com',
            faviconUrl: 'http://test.com/favicon.png',
            notes: null,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          when(
            () => mockUpdateCredentialUseCase.call(any()),
          ).thenThrow(Exception('Erro ao atualizar'));

          await controller.errorFavIcon(credential);

          verify(() => mockUpdateCredentialUseCase.call(any())).called(1);
        },
      );
    });

    group('onReady', () {
      test('deve chamar initLocalDatabase e getAllCredentials', () async {
        when(
          () => mockCredentialRepository.initLocalDatabase(),
        ).thenAnswer((_) async {});
        when(
          () => mockListCredentialUseCase.call(),
        ).thenAnswer((_) async => []);

        await controller.onReady();

        verify(() => mockCredentialRepository.initLocalDatabase()).called(1);
        verify(() => mockListCredentialUseCase.call()).called(1);
      });
    });

    group('credentials', () {
      test('deve retornar valueListenable do repository', () {
        final result = controller.credentials;

        expect(result, mockCredentialRepository.valueListenable);
      });
    });
  });
}
