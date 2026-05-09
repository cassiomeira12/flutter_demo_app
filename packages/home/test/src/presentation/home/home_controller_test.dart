import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/src/presentation/home/home_controller.dart';

class MockCheckInternetConnectionUseCase extends Mock
    implements CheckInternetConnectionUseCase {}

void main() {
  late MockCheckInternetConnectionUseCase mockCheckInternetUseCase;
  late HomeController homeController;

  setUpAll(() {
    registerFallbackValue('');
    WidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true;
  });

  setUp(() {
    mockCheckInternetUseCase = MockCheckInternetConnectionUseCase();

    when(
      () => mockCheckInternetUseCase.internetStream,
    ).thenAnswer((_) => const Stream<bool>.empty());
    when(() => mockCheckInternetUseCase.pauseStream()).thenReturn(null);
    when(() => mockCheckInternetUseCase.resumeStream()).thenReturn(null);
    when(() => mockCheckInternetUseCase.dispose()).thenReturn(null);

    homeController = HomeController(
      checkInternetUseCase: mockCheckInternetUseCase,
    );
  });

  group('HomeController', () {
    group('changeTab', () {
      test('deve alterar o indice selecionado quando diferente do atual', () {
        // arrange
        const novaIndex = 2;

        // act
        homeController.changeTab(novaIndex, 'test_key');

        // assert
        expect(homeController.selectedIndex.value, novaIndex);
      });

      test('nao deve alterar quando indice e igual ao atual', () {
        // arrange
        const novaIndex = 1;
        homeController.selectedIndex.value = novaIndex;

        // act
        homeController.changeTab(novaIndex, 'test_key');

        // assert
        expect(homeController.selectedIndex.value, novaIndex);
        verifyNever(() => mockCheckInternetUseCase.pauseStream());
      });
    });

    group('internetConnectionListener', () {
      test('deve executar logica quando conexao esta indisponivel', () {
        // arrange - nao tem retorno, so executa a logica interna
        // act
        homeController.internetConnectionListener(false);

        // assert - o metodo executa sem erro
        expect(homeController, isNotNull);
      });

      test('nao deve fazer nada quando conexao esta disponivel', () {
        // arrange & act
        homeController.internetConnectionListener(true);

        // assert - o metodo executa sem erro
        expect(homeController, isNotNull);
      });
    });

    group('onReady', () {
      test('deve configurar listener de conexao com internet', () async {
        // arrange
        final streamController = StreamController<bool>.broadcast();
        when(
          () => mockCheckInternetUseCase.internetStream,
        ).thenAnswer((_) => streamController.stream);
        when(() => mockCheckInternetUseCase.pauseStream()).thenReturn(null);
        when(() => mockCheckInternetUseCase.resumeStream()).thenReturn(null);

        // act
        homeController.onReady();

        // assert
        verify(() => mockCheckInternetUseCase.internetStream).called(1);

        // cleanup
        await streamController.close();
      });
    });

    group('onAppResumed', () {
      test('deve chamar resumeStream ao retomar app', () {
        // arrange & act
        homeController.onAppResumed();

        // assert
        verify(() => mockCheckInternetUseCase.resumeStream()).called(1);
      });

      test('deve lancar excecao quando resumeStream falha', () {
        // arrange
        when(
          () => mockCheckInternetUseCase.resumeStream(),
        ).thenThrow(Exception('Erro ao resume stream'));

        // act & assert
        expect(
          () => homeController.onAppResumed(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('onAppBackground', () {
      test('deve chamar pauseStream ao enviar app para background', () {
        // arrange & act
        homeController.onAppBackground();

        // assert
        verify(() => mockCheckInternetUseCase.pauseStream()).called(1);
      });

      test('deve lancar excecao quando pauseStream falha', () {
        // arrange
        when(
          () => mockCheckInternetUseCase.pauseStream(),
        ).thenThrow(Exception('Erro ao pausar stream'));

        // act & assert
        expect(
          () => homeController.onAppBackground(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('onClose', () {
      test('deve chamar dispose ao fechar controller', () {
        // arrange & act
        homeController.onClose();

        // assert
        verify(() => mockCheckInternetUseCase.dispose()).called(1);
      });

      test('deve lancar excecao quando dispose falha', () {
        // arrange
        when(
          () => mockCheckInternetUseCase.dispose(),
        ).thenThrow(Exception('Erro ao dispose'));

        // act & assert
        expect(
          () => homeController.onClose(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('selectedIndex', () {
      test('deve iniciar com valor padrao do navigatorIndex', () {
        // assert
        expect(
          homeController.selectedIndex.value,
          BaseController.navigatorIndex,
        );
      });

      test('deve permitir alteracao de valor', () {
        // arrange
        const novoValor = 5;

        // act
        homeController.selectedIndex.value = novoValor;

        // assert
        expect(homeController.selectedIndex.value, novoValor);
      });
    });
  });
}
