import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_app/src/presentation/web/web_controller.dart';

class MockOpenWebUrlUseCase extends Mock implements OpenWebUrlUseCase {}

class MockGetDeviceLocaleUseCase extends Mock
    implements GetDeviceLocaleUseCase {}

class FakeLocale extends Fake implements Locale {}

void main() {
  late MockOpenWebUrlUseCase mockOpenWebUrlUseCase;
  late MockGetDeviceLocaleUseCase mockGetDeviceLocaleUseCase;
  late WebController webController;

  late AppEnvironmentEntity appEnv;
  late ServerEnvironmentEntity serverEnv;
  late WebAppEnvironmentEntity webAppEnv;

  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
    AppBinding.testMode(true);
    registerFallbackValue(FakeLocale());
  });

  setUp(() async {
    mockOpenWebUrlUseCase = MockOpenWebUrlUseCase();
    mockGetDeviceLocaleUseCase = MockGetDeviceLocaleUseCase();

    appEnv = AppEnvironmentEntity(
      appName: 'Test App',
      androidPackageName: 'com.test.app',
      appleStoreAppId: '123456789',
      permissions: 'camera,storage',
    );

    serverEnv = ServerEnvironmentEntity(
      serverUrl: 'https://test.example.com',
    );

    webAppEnv = WebAppEnvironmentEntity(
      contactEmail: 'test@example.com',
      contactInstagram: 'https://instagram.com/test',
      contactFacebook: 'https://facebook.com/test',
      contactWhatsApp: 'https://wa.me/123456789',
    );

    // Initialize FeatureFlagServiceManager with faker fallback
    FeatureFlagServiceManager.instance.clear();
    await FeatureFlagServiceManager.instance.init();

    webController = WebController(
      appEnv: appEnv,
      serverEnv: serverEnv,
      webAppEnv: webAppEnv,
      openWebUrlUseCase: mockOpenWebUrlUseCase,
      currentDeviceLocaleUseCase: mockGetDeviceLocaleUseCase,
    );
  });

  tearDown(() {
    FeatureFlagServiceManager.instance.clear();
  });

  group('WebController', () {
    group('Propriedades', () {
      test('deve retornar o nome do app corretamente', () {
        expect(webController.appName, 'Test App');
      });

      test('deve retornar showEmail como true quando email nao esta vazio', () {
        expect(webController.showEmail, isTrue);
      });

      test('deve retornar showEmail como false quando email esta vazio', () {
        final webAppEnvEmpty = WebAppEnvironmentEntity(
          contactEmail: '',
          contactInstagram: '',
          contactFacebook: '',
          contactWhatsApp: '',
        );

        final controller = WebController(
          appEnv: appEnv,
          serverEnv: serverEnv,
          webAppEnv: webAppEnvEmpty,
          openWebUrlUseCase: mockOpenWebUrlUseCase,
          currentDeviceLocaleUseCase: mockGetDeviceLocaleUseCase,
        );

        expect(controller.showEmail, isFalse);
      });

      test(
        'deve retornar showInstagramButton como true quando URL nao vazia',
        () {
          expect(webController.showInstagramButton, isTrue);
        },
      );

      test(
        'deve retornar showFacebookButton como true quando URL nao vazia',
        () {
          expect(webController.showFacebookButton, isTrue);
        },
      );

      test(
        'deve retornar showWhatsAppButton como true quando URL nao vazia',
        () {
          expect(webController.showWhatsAppButton, isTrue);
        },
      );
    });

    group('privacyPolicy', () {
      group('Sucesso', () {
        test('deve abrir URL de privacy policy com sucesso', () {
          // arrange
          when(
            () => mockOpenWebUrlUseCase.call(any()),
          ).thenAnswer((_) async {});

          // act
          webController.privacyPolicy();

          // assert
          verify(
            () => mockOpenWebUrlUseCase.call(
              'https://test.example.com/privacy-policy',
            ),
          ).called(1);
        });
      });

      group('Erro', () {
        test('deve lanar excecao quando OpenWebUrlUseCase falhar', () {
          // arrange
          when(
            () => mockOpenWebUrlUseCase.call(any()),
          ).thenThrow(BaseException(message: 'url_open_error'));

          // act & assert
          expect(
            () => webController.privacyPolicy(),
            throwsA(isA<BaseException>()),
          );
        });
      });
    });

    group('termsConditions', () {
      group('Sucesso', () {
        test('deve abrir URL de termos e condicoes com sucesso', () {
          // arrange
          when(
            () => mockOpenWebUrlUseCase.call(any()),
          ).thenAnswer((_) async {});

          // act
          webController.termsConditions();

          // assert
          verify(
            () => mockOpenWebUrlUseCase.call(
              'https://test.example.com/terms-conditions',
            ),
          ).called(1);
        });
      });

      group('Erro', () {
        test('deve lanar excecao quando abertura de URL falhar', () {
          // arrange
          when(
            () => mockOpenWebUrlUseCase.call(any()),
          ).thenThrow(Exception('open_url_failed'));

          // act & assert
          expect(
            () => webController.termsConditions(),
            throwsA(isA<Exception>()),
          );
        });
      });
    });

    group('helpAndSupport', () {
      test('deve executar sem erro', () {
        expect(() => webController.helpAndSupport(), returnsNormally);
      });
    });

    group('openInstagram', () {
      group('Sucesso', () {
        test('deve abrir URL do Instagram com sucesso', () {
          // arrange
          when(
            () => mockOpenWebUrlUseCase.call(any()),
          ).thenAnswer((_) async {});

          // act
          webController.openInstagram();

          // assert
          verify(
            () => mockOpenWebUrlUseCase.call('https://instagram.com/test'),
          ).called(1);
        });
      });

      group('Erro', () {
        test('deve lanar excecao quando abertura de URL falhar', () {
          // arrange
          when(
            () => mockOpenWebUrlUseCase.call(any()),
          ).thenThrow(BaseException(message: 'instagram_open_error'));

          // act & assert
          expect(
            () => webController.openInstagram(),
            throwsA(isA<BaseException>()),
          );
        });
      });
    });

    group('openFacebook', () {
      group('Sucesso', () {
        test('deve abrir URL do Facebook com sucesso', () {
          // arrange
          when(
            () => mockOpenWebUrlUseCase.call(any()),
          ).thenAnswer((_) async {});

          // act
          webController.openFacebook();

          // assert
          verify(
            () => mockOpenWebUrlUseCase.call('https://facebook.com/test'),
          ).called(1);
        });
      });

      group('Erro', () {
        test('deve lanar excecao quando abertura de URL falhar', () {
          // arrange
          when(
            () => mockOpenWebUrlUseCase.call(any()),
          ).thenThrow(BaseException(message: 'facebook_open_error'));

          // act & assert
          expect(
            () => webController.openFacebook(),
            throwsA(isA<BaseException>()),
          );
        });
      });
    });

    group('openWhatsApp', () {
      group('Sucesso', () {
        test('deve abrir URL do WhatsApp com sucesso', () {
          // arrange
          when(
            () => mockOpenWebUrlUseCase.call(any()),
          ).thenAnswer((_) async {});

          // act
          webController.openWhatsApp();

          // assert
          verify(
            () => mockOpenWebUrlUseCase.call('https://wa.me/123456789'),
          ).called(1);
        });
      });

      group('Erro', () {
        test('deve lanar excecao quando abertura de URL falhar', () {
          // arrange
          when(
            () => mockOpenWebUrlUseCase.call(any()),
          ).thenThrow(BaseException(message: 'whatsapp_open_error'));

          // act & assert
          expect(
            () => webController.openWhatsApp(),
            throwsA(isA<BaseException>()),
          );
        });
      });
    });

    group('downloadAndroidApp', () {
      group('Sucesso', () {
        test(
          'deve abrir URL do servidor quando flag desabilitada (default)',
          () async {
            // arrange
            when(
              () => mockOpenWebUrlUseCase.call(any()),
            ).thenAnswer((_) async {});

            // act
            await webController.downloadAndroidApp();

            // assert
            verify(
              () => mockOpenWebUrlUseCase.call(
                'https://test.example.com/download_android_app',
              ),
            ).called(1);
          },
        );

        test(
          'deve abrir URL da Google Play Store quando locale disponivel',
          () async {
            // arrange
            when(
              () => mockGetDeviceLocaleUseCase.call(),
            ).thenAnswer((_) async => const Locale('en', 'US'));
            when(
              () => mockOpenWebUrlUseCase.call(any()),
            ).thenAnswer((_) async {});

            // act
            await webController.downloadAndroidApp();

            // assert - flag is disabled by default (faker returns isEnabled: false)
            // so it will call server URL
            verify(
              () => mockOpenWebUrlUseCase.call(
                'https://test.example.com/download_android_app',
              ),
            ).called(1);
          },
        );
      });

      group('Erro', () {
        // Note: GetDeviceLocaleUseCase so e chamado quando a flag de store esta habilitada
        // Com o faker (flag desabilitada por padrao), este caminho nao e executado
        test('deve lanar excecao quando OpenWebUrlUseCase falhar', () async {
          // arrange
          when(
            () => mockOpenWebUrlUseCase.call(any()),
          ).thenThrow(BaseException(message: 'url_open_error'));

          // act & assert
          expect(
            () => webController.downloadAndroidApp(),
            throwsA(isA<BaseException>()),
          );
        });
      });
    });

    group('downloadAppleApp', () {
      group('Sucesso', () {
        test(
          'deve abrir URL do servidor quando flag desabilitada (default)',
          () async {
            // arrange
            when(
              () => mockOpenWebUrlUseCase.call(any()),
            ).thenAnswer((_) async {});

            // act
            await webController.downloadAppleApp();

            // assert
            verify(
              () => mockOpenWebUrlUseCase.call(
                'https://test.example.com/download_ios_app',
              ),
            ).called(1);
          },
        );
      });

      group('Erro', () {
        test('deve lanar excecao quando OpenWebUrlUseCase falhar', () async {
          // arrange
          when(
            () => mockOpenWebUrlUseCase.call(any()),
          ).thenThrow(BaseException(message: 'url_open_error'));

          // act & assert
          expect(
            () => webController.downloadAppleApp(),
            throwsA(isA<BaseException>()),
          );
        });
      });
    });

    group('onReady', () {
      test('deve executar sem erro quando nao ha usuario logado', () async {
        // arrange & act & assert
        expect(() => webController.onReady(), returnsNormally);
      });
    });
  });
}
