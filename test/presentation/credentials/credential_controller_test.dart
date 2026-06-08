import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/domain/domain.dart';
import 'package:flutter_demo_app/presentation/credential/credential.dart';
import 'package:flutter_demo_app/presentation/credentials/credentials.dart';
import 'package:flutter_test/flutter_test.dart';

class MockCreateCredentialUseCase extends Mock
    implements CreateCredentialUseCase {}

class MockUpdateCredentialUseCase extends Mock
    implements UpdateCredentialUseCase {}

class MockDeleteCredentialUseCase extends Mock
    implements DeleteCredentialUseCase {}

class MockCredentialsStore extends Mock implements CredentialsStore {}

class MockClipboardUseCase extends Mock implements ClipboardUseCase {}

class MockOpenWebUrlUseCase extends Mock implements OpenWebUrlUseCase {}

class MockCredentialRepository extends Mock implements CredentialRepository {}

class FakeCredentialEntity extends Fake implements CredentialEntity {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  late MockCreateCredentialUseCase mockCreateCredentialUseCase;
  late MockUpdateCredentialUseCase mockUpdateCredentialUseCase;
  late MockDeleteCredentialUseCase mockDeleteCredentialUseCase;
  late MockCredentialsStore mockCredentialsStore;
  late MockClipboardUseCase mockClipboardUseCase;
  late MockOpenWebUrlUseCase mockOpenWebUrlUseCase;
  late CredentialController controller;

  setUpAll(() {
    registerFallbackValue(FakeCredentialEntity());
  });

  setUp(() {
    mockCreateCredentialUseCase = MockCreateCredentialUseCase();
    mockUpdateCredentialUseCase = MockUpdateCredentialUseCase();
    mockDeleteCredentialUseCase = MockDeleteCredentialUseCase();
    mockCredentialsStore = MockCredentialsStore();
    mockClipboardUseCase = MockClipboardUseCase();
    mockOpenWebUrlUseCase = MockOpenWebUrlUseCase();

    final mockRxn = Rxn<CredentialEntity>();
    when(() => mockCredentialsStore.credential).thenReturn(mockRxn);

    when(() => mockCredentialsStore.indexOf(any())).thenReturn(0);

    controller = CredentialController(
      createCredentialUseCase: mockCreateCredentialUseCase,
      updateCredentialUseCase: mockUpdateCredentialUseCase,
      deleteCredentialUseCase: mockDeleteCredentialUseCase,
      credentialsStore: mockCredentialsStore,
      clipboardUseCase: mockClipboardUseCase,
      openWebUrlUseCase: mockOpenWebUrlUseCase,
    );
  });

  group('CredentialController', () {
    group('saveCredential - Criar nova credencial', () {
      test(
        'deve retornar sucesso quando _createCredentialUseCase.call() executar corretamente',
        () async {
          when(() => mockCreateCredentialUseCase.call(any())).thenAnswer(
            (_) async => CredentialEntity(
              objectId: '123',
              name: 'Test Credential',
              userName: 'user@test.com',
              password: 'password123',
              secretKeyOTP: null,
              url: 'https://test.com',
              faviconUrl: null,
              notes: null,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );

          await controller.saveCredential(
            credentialName: 'Test Credential',
            userName: 'user@test.com',
            password: 'password123',
            secretKeyOTP: '',
            url: 'https://test.com',
            notes: '',
          );

          verify(() => mockCreateCredentialUseCase.call(any())).called(1);
        },
      );

      test(
        'deve lanar BaseException quando _createCredentialUseCase lanar BaseException',
        () async {
          when(() => mockCreateCredentialUseCase.call(any())).thenThrow(
            BaseException(
              message: 'Erro ao criar credencial',
              throwReport: false,
            ),
          );

          expect(
            () => controller.saveCredential(
              credentialName: 'Test Credential',
              userName: 'user@test.com',
              password: 'password123',
              secretKeyOTP: '',
              url: 'https://test.com',
              notes: '',
            ),
            throwsA(isA<BaseException>()),
          );
        },
      );

      test(
        'deve lanar Exception quando _createCredentialUseCase lanar Exception',
        () async {
          when(
            () => mockCreateCredentialUseCase.call(any()),
          ).thenThrow(Exception('Erro generico'));

          expect(
            () => controller.saveCredential(
              credentialName: 'Test Credential',
              userName: 'user@test.com',
              password: 'password123',
              secretKeyOTP: '',
              url: 'https://test.com',
              notes: '',
            ),
            throwsA(isA<Exception>()),
          );
        },
      );
    });

    group('saveCredential - Atualizar credencial existente', () {
      test(
        'deve retornar sucesso quando _updateCredentialUseCase.call() executar corretamente',
        () async {
          final existingCredential = CredentialEntity(
            objectId: '123',
            name: 'Existing Credential',
            userName: 'olduser@test.com',
            password: 'oldpassword',
            secretKeyOTP: null,
            url: 'https://oldtest.com',
            faviconUrl: null,
            notes: null,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          final mockRxn = Rxn<CredentialEntity>();
          when(() => mockCredentialsStore.credential).thenReturn(mockRxn);
          mockRxn.value = existingCredential;

          when(() => mockUpdateCredentialUseCase.call(any())).thenAnswer(
            (_) async => CredentialEntity(
              objectId: '123',
              name: 'Updated Credential',
              userName: 'newuser@test.com',
              password: 'newpassword',
              secretKeyOTP: null,
              url: 'https://newtest.com',
              faviconUrl: null,
              notes: null,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );

          await controller.saveCredential(
            credentialName: 'Updated Credential',
            userName: 'newuser@test.com',
            password: 'newpassword',
            secretKeyOTP: '',
            url: 'https://newtest.com',
            notes: '',
          );

          verify(() => mockUpdateCredentialUseCase.call(any())).called(1);
        },
      );

      test(
        'deve lanar BaseException quando _updateCredentialUseCase lanar BaseException',
        () async {
          final existingCredential = CredentialEntity(
            objectId: '123',
            name: 'Existing Credential',
            userName: 'olduser@test.com',
            password: 'oldpassword',
            secretKeyOTP: null,
            url: 'https://oldtest.com',
            faviconUrl: null,
            notes: null,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          final mockRxn = Rxn<CredentialEntity>();
          when(() => mockCredentialsStore.credential).thenReturn(mockRxn);
          mockRxn.value = existingCredential;

          when(() => mockUpdateCredentialUseCase.call(any())).thenThrow(
            BaseException(message: 'Erro ao atualizar', throwReport: false),
          );

          expect(
            () => controller.saveCredential(
              credentialName: 'Updated Credential',
              userName: 'newuser@test.com',
              password: 'newpassword',
              secretKeyOTP: '',
              url: 'https://newtest.com',
              notes: '',
            ),
            throwsA(isA<BaseException>()),
          );
        },
      );
    });

    group('removerCredential', () {
      test(
        'deve retornar sucesso quando _deleteCredentialUseCase.call() executar corretamente',
        () async {
          final credential = CredentialEntity(
            objectId: '123',
            name: 'Test Credential',
            userName: 'user@test.com',
            password: 'password123',
            secretKeyOTP: null,
            url: 'https://test.com',
            faviconUrl: null,
            notes: null,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          final mockRxn = Rxn<CredentialEntity>();
          when(() => mockCredentialsStore.credential).thenReturn(mockRxn);
          mockRxn.value = credential;

          when(
            () => mockDeleteCredentialUseCase.call(any()),
          ).thenAnswer((_) async {});

          await controller.removerCredential();

          verify(() => mockDeleteCredentialUseCase.call(any())).called(1);
        },
      );

      test(
        'deve tratar erro silenciosamente quando _deleteCredentialUseCase lanar excecao',
        () async {
          final credential = CredentialEntity(
            objectId: '123',
            name: 'Test Credential',
            userName: 'user@test.com',
            password: 'password123',
            secretKeyOTP: null,
            url: 'https://test.com',
            faviconUrl: null,
            notes: null,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          final mockRxn = Rxn<CredentialEntity>();
          when(() => mockCredentialsStore.credential).thenReturn(mockRxn);
          mockRxn.value = credential;

          when(
            () => mockDeleteCredentialUseCase.call(any()),
          ).thenThrow(Exception('Erro ao deletar'));

          await controller.removerCredential();

          verify(() => mockDeleteCredentialUseCase.call(any())).called(1);
        },
      );
    });

    group('nameValidator', () {
      test('deve retornar erro quando nome for vazio', () {
        final result = controller.nameValidator('');

        expect(result, isNotNull);
      });

      test('deve retornar erro quando nome for apenas espacos', () {
        final result = controller.nameValidator('   ');

        expect(result, isNotNull);
      });

      test('deve retornar null quando nome for valido', () {
        final result = controller.nameValidator('My Credential');

        expect(result, isNull);
      });
    });

    group('passwordValidator', () {
      test('deve retornar null quando senha for vazia', () {
        final result = controller.passwordValidator('');

        expect(result, isNull);
      });

      test(
        'deve retornar null quando senha nao foi usada em outras credenciais',
        () {
          final mockRepo = MockCredentialRepository();
          when(() => mockRepo.valueListenable).thenReturn(
            ValueNotifier<List<ValueNotifier<CredentialEntity>>>([]),
          );

          final store = CredentialsStore(credentialRepository: mockRepo);

          final controllerWithStore = CredentialController(
            createCredentialUseCase: mockCreateCredentialUseCase,
            updateCredentialUseCase: mockUpdateCredentialUseCase,
            deleteCredentialUseCase: mockDeleteCredentialUseCase,
            credentialsStore: store,
            clipboardUseCase: mockClipboardUseCase,
            openWebUrlUseCase: mockOpenWebUrlUseCase,
          );

          final result = controllerWithStore.passwordValidator('newpassword');

          expect(result, isNull);
        },
      );
    });

    group('urlValidation', () {
      test('deve retornar null quando URL for vazia', () {
        controller.urlValidation('');

        expect(controller.showOpenUrl.value, false);
      });

      test('deve retornar erro quando URL for invalida', () {
        final result = controller.urlValidation('not-a-valid-url');

        expect(result, isNotNull);
        expect(controller.showOpenUrl.value, false);
      });

      test(
        'deve retornar null e setar showOpenUrl true quando URL for valida',
        () {
          controller.urlValidation('https://test.com');

          expect(controller.showOpenUrl.value, true);
          expect(controller.favIconUrl.value, isNotEmpty);
        },
      );
    });

    group('changeSecretKeyOTP', () {
      test('deve setar showOtpWidget false quando OTP for vazio', () {
        controller.changeSecretKeyOTP('');

        expect(controller.showOtpWidget.value, false);
      });

      test('deve setar showOtpWidget false quando OTP for invalido', () {
        controller.changeSecretKeyOTP('invalid-otp');

        expect(controller.showOtpWidget.value, false);
      });

      test('deve setar showOtpWidget true quando OTP for valido', () {
        controller.changeSecretKeyOTP('JBSWY3DPEHPK3PXP');

        expect(controller.showOtpWidget.value, true);
      });
    });

    group('copyText', () {
      test('deve chamar clipboardUseCase.copy() com sucesso', () async {
        when(
          () => mockClipboardUseCase.copy(
            any(),
            autoClear: any(named: 'autoClear'),
          ),
        ).thenAnswer((_) async {});

        await controller.copyText('test text');

        verify(
          () => mockClipboardUseCase.copy('test text'),
        ).called(1);
      });

      test(
        'deve lancar erro quando clipboardUseCase.copy() falhar',
        () async {
          when(
            () => mockClipboardUseCase.copy(
              any(),
              autoClear: any(named: 'autoClear'),
            ),
          ).thenThrow(Exception('Erro ao copiar'));

          expect(
            () => controller.copyText('test text'),
            throwsA(isA<Exception>()),
          );
        },
      );
    });

    group('openUrl', () {
      test('deve chamar openWebUrlUseCase.call() com sucesso', () {
        controller.urlTextController.text = 'https://test.com';

        when(() => mockOpenWebUrlUseCase.call(any())).thenAnswer((_) async {});

        controller.openUrl();

        verify(() => mockOpenWebUrlUseCase.call('https://test.com')).called(1);
      });
    });
  });
}
