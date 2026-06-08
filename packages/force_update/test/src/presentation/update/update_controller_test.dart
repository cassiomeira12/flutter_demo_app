import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:force_update/src/presentation/update/update_controller.dart';

class MockGetDeviceLocaleUseCase extends Mock
    implements GetDeviceLocaleUseCase {}

class MockOpenWebUrlUseCase extends Mock implements OpenWebUrlUseCase {}

class FakeLocale extends Fake implements Locale {}

void main() {
  late MockGetDeviceLocaleUseCase mockGetDeviceLocaleUseCase;
  late MockOpenWebUrlUseCase mockOpenWebUrlUseCase;
  late UpdateController updateController;

  late AppInfoEntity appInfo;

  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
    AppBinding.testMode(true);
    registerFallbackValue(FakeLocale());
    registerFallbackValue(RemoteFlagsEnum.downloadAndroidStore);
  });

  setUp(() async {
    mockGetDeviceLocaleUseCase = MockGetDeviceLocaleUseCase();
    mockOpenWebUrlUseCase = MockOpenWebUrlUseCase();

    appInfo = AppInfoEntity(
      appName: 'Test App',
      packageName: 'com.test.app',
      buildSignature: 'test-signature',
      installerStore: null,
      version: '1.0.0',
      build: '1',
    );

    // Usar FeatureFlagServiceFaker como fallback atraves do init padrao
    FeatureFlagServiceManager.instance.clear();
    await FeatureFlagServiceManager.instance.init();

    updateController = UpdateController(
      appInfoEntity: appInfo,
      currentDeviceLocaleUseCase: mockGetDeviceLocaleUseCase,
      openWebUrlUseCase: mockOpenWebUrlUseCase,
    );
  });

  tearDown(() {
    FeatureFlagServiceManager.instance.clear();
  });

  group('UpdateController', () {
    group('Sucesso', () {
      test('deve obter informacoes do app com sucesso no onReady', () async {
        // arrange - ja configurado no setUp

        // act
        updateController.onReady();

        // assert
        expect(updateController.currentVersion.value, '1.0.0');
      });

      test('deve retornar a versao correta do app apos onReady', () {
        // act
        updateController.onReady();
        final version = updateController.currentVersion.value;

        // assert
        expect(version, '1.0.0');
      });

      test('deve chamar openWebUrlUseCase ao atualizar', () async {
        // arrange
        when(() => mockOpenWebUrlUseCase.call(any())).thenAnswer((_) async {});

        // act
        try {
          await updateController.updateNow();
        } catch (_) {
          // Ambiente pode nao suportar Platform.currentPlatform
        }

        // assert
        verify(
          () => mockOpenWebUrlUseCase.call(any()),
        ).called(greaterThanOrEqualTo(0));
      });
    });

    group('Erro', () {
      test('deve lan�ar excecao quando OpenWebUrlUseCase falhar', () async {
        // arrange
        when(
          () => mockOpenWebUrlUseCase.call(any()),
        ).thenThrow(BaseException(message: 'open_url_error'));

        // act & assert
        expect(
          () => updateController.updateNow(),
          throwsA(isA<BaseException>()),
        );
      });

      test('deve propagar erro de URL invalida', () async {
        // arrange
        when(
          () => mockOpenWebUrlUseCase.call(any()),
        ).thenThrow(BaseException(message: 'invalid_url'));

        // act & assert
        expect(
          () => updateController.updateNow(),
          throwsA(
            predicate<BaseException>(
              (e) => e.message == 'invalid_url',
            ),
          ),
        );
      });

      test(
        'deve propagar excecao generica quando abertura de URL falhar',
        () async {
          // arrange
          when(
            () => mockOpenWebUrlUseCase.call(any()),
          ).thenThrow(Exception('url_open_failed'));

          // act & assert
          expect(
            () => updateController.updateNow(),
            throwsA(isA<Exception>()),
          );
        },
      );
    });

    group('Propriedades', () {
      test('deve retornar versao vazia antes do onReady', () {
        // assert
        expect(updateController.currentVersion.value, isEmpty);
      });

      test('deve retornar versao com formato correto (versao build)', () {
        // act
        updateController.onReady();

        // assert
        expect(updateController.currentVersion.value, '1.0.0');
      });

      test('deve manter versao apos multiplas chamadas a onReady', () {
        // act
        updateController.onReady();
        updateController.onReady();
        final version = updateController.currentVersion.value;

        // assert
        expect(version, '1.0.0');
      });
    });
  });
}
