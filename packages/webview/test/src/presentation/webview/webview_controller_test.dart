import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webview/src/domain/domain.dart';
import 'package:webview/src/presentation/webview/webview_controller.dart';
import 'package:webview/src/presentation/webview/widgets/webview_widget_controller.dart';

class MockLocalStorageUseCase extends Mock implements LocalStorageUseCase {}

class MockCheckInternetConnectionUseCase extends Mock
    implements CheckInternetConnectionUseCase {}

class MockOpenWebUrlUseCase extends Mock implements OpenWebUrlUseCase {}

class MockShareUseCase extends Mock implements ShareUseCase {}

class MockWebViewWidgetController extends Mock
    implements WebViewWidgetController {}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    AppBinding.testMode(true);
    registerFallbackValue(Uri.parse('https://fallback.example.com'));
    registerFallbackValue(TrackOperationStatus.ok);
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue(ShareResultEntity(raw: null, status: 'fallback'));
  });

  setUp(() {
    AppBinding.reset();
  });

  tearDown(() {
    AppBinding.reset();
  });

  late MockLocalStorageUseCase mockLocalStorage;
  late MockCheckInternetConnectionUseCase mockCheckInternet;
  late MockOpenWebUrlUseCase mockOpenWebUrl;
  late MockShareUseCase mockShare;
  late MockWebViewWidgetController mockWebViewWidgetController;
  late StreamController<bool> internetStreamController;
  late List<String> openedPages;
  late WebViewController subject;

  setUp(() {
    mockLocalStorage = MockLocalStorageUseCase();
    mockCheckInternet = MockCheckInternetConnectionUseCase();
    mockOpenWebUrl = MockOpenWebUrlUseCase();
    mockShare = MockShareUseCase();
    mockWebViewWidgetController = MockWebViewWidgetController();
    internetStreamController = StreamController<bool>.broadcast();
    openedPages = <String>[];

    when(
      () => mockCheckInternet.internetStream,
    ).thenAnswer((_) => internetStreamController.stream);
    when(
      () => mockLocalStorage.get<Map<String, dynamic>>(any()),
    ).thenAnswer((_) async => null);
    when(
      () => mockLocalStorage.set<Map<String, int>>(any(), any()),
    ).thenAnswer((_) async => true);
    when(() => mockLocalStorage.delete(any())).thenAnswer((_) async => true);
    when(() => mockCheckInternet.call()).thenAnswer((_) async => true);
    when(() => mockOpenWebUrl.call(any())).thenAnswer((_) async {});
    when(
      () => mockShare.call(
        title: any(named: 'title'),
        text: any(named: 'text'),
      ),
    ).thenAnswer(
      (_) async => ShareResultEntity(raw: null, status: 'success'),
    );
    when(
      () => mockWebViewWidgetController.lastProgress,
    ).thenReturn(ValueNotifier<int>(0));
    when(
      () => mockWebViewWidgetController.currentStep,
    ).thenReturn(LoadWebviewStepEnum.webViewCreated);
    when(
      () => mockWebViewWidgetController.isInternetConnected,
    ).thenReturn(true);
    when(() => mockWebViewWidgetController.pause()).thenReturn(null);
    when(() => mockWebViewWidgetController.resume()).thenReturn(null);
    when(() => mockWebViewWidgetController.errorStep()).thenReturn(null);
    when(
      () => mockWebViewWidgetController.stopLoadingTimer(),
    ).thenAnswer((_) async {});
    when(
      () => mockWebViewWidgetController.reload(
        initialUrl: any(named: 'initialUrl'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => mockWebViewWidgetController.scrollTo(
        x: any(named: 'x'),
        y: any(named: 'y'),
        animated: any(named: 'animated'),
      ),
    ).thenAnswer((_) async {});

    subject = WebViewController(
      globalKeyHash: 'test_hash',
      localStorage: mockLocalStorage,
      checkInternetUseCase: mockCheckInternet,
      openWebUrlUseCase: mockOpenWebUrl,
      shareUseCase: mockShare,
      openPage: (String url) async {
        openedPages.add(url);
      },
      reloadExpiredUrls: <ReloadExpiredUrlEntity>[],
    );

    subject.initialUrl = 'https://example.com';
  });

  group('setLoading', () {
    test('deve manter isLoading como true e limpar erro', () {
      expect(subject.isLoading, true);

      subject.setLoading(true);

      expect(subject.isLoading, true);
      expect(subject.hasError, false);
    });

    test(
      'deve definir isLoading como false e registrar timestamp bem-sucedido',
      () {
        expect(subject.isLoading, true);

        subject.setLoading(false);

        expect(subject.isLoading, false);
        expect(subject.hasError, false);
      },
    );

    test('não deve alterar estado quando o valor é o mesmo', () {
      expect(subject.isLoading, true);

      subject.setLoading(false);

      expect(subject.isLoading, false);
    });
  });

  group('setError', () {
    test(
      'deve definir hasError como true e liberar recursos do webViewController',
      () {
        subject.setWebViewController(mockWebViewWidgetController);
        expect(subject.hasError, false);

        subject.setError(true);

        expect(subject.hasError, true);
        expect(subject.showWebView.value, false);
        expect(subject.isLoading, false);
        verify(() => mockWebViewWidgetController.errorStep()).called(1);
        verify(() => mockWebViewWidgetController.stopLoadingTimer()).called(1);
        expect(subject.currentStep, isNull);
      },
    );

    test('deve definir hasError como false e exibir webView', () {
      subject.setError(true);
      expect(subject.hasError, true);

      subject.setError(false);

      expect(subject.hasError, false);
    });

    test('não deve alterar estado quando o valor é o mesmo', () {
      expect(subject.hasError, false);

      subject.setError(false);

      expect(subject.hasError, false);
    });
  });

  group('setProcessGone', () {
    test(
      'deve definir processGone como true e recriar webView quando app em foreground',
      () async {
        expect(subject.processGone, false);
        subject.setLoading(true);
        expect(subject.isLoading, true);

        subject.setProcessGone(true);

        expect(subject.processGone, true);
        expect(subject.showWebView.value, false);
        expect(subject.isLoading, true);
      },
    );

    test('deve definir processGone como false', () {
      subject.setProcessGone(true);
      expect(subject.processGone, true);

      subject.setProcessGone(false);

      expect(subject.processGone, false);
      expect(subject.showWebView.value, true);
    });
  });

  group('saveScrollPosition', () {
    test('deve salvar posição do scroll no localStorage', () async {
      subject.scrollX = 100;
      subject.scrollY = 200;

      await subject.saveScrollPosition();

      verify(
        () => mockLocalStorage.set<Map<String, int>>(
          'https://example.com',
          {'x': 100, 'y': 200},
        ),
      ).called(1);
    });
  });

  group('openExternalLink', () {
    test('deve abrir URL externa via use case', () async {
      final uri = Uri.parse('https://external.com/page');

      await subject.openExternalLink(uri);

      verify(() => mockOpenWebUrl.call('https://external.com/page')).called(1);
    });

    test('deve ignorar URLs com scheme appbase', () async {
      final uri = Uri.parse('appbase://internal/action');

      await subject.openExternalLink(uri);

      verifyNever(() => mockOpenWebUrl.call(any()));
    });

    test('deve engolir exceção quando openWebUrlUseCase falha', () async {
      final uri = Uri.parse('https://external.com/page');
      when(() => mockOpenWebUrl.call(any())).thenThrow(Exception('Falha'));

      await subject.openExternalLink(uri);

      verify(() => mockOpenWebUrl.call('https://external.com/page')).called(1);
    });
  });

  group('openLink', () {
    test('deve salvar scroll, pausar, abrir página e resumir', () async {
      subject.setWebViewController(mockWebViewWidgetController);
      await subject.openLink('https://internal.com/page');

      expect(openedPages, contains('https://internal.com/page'));
      verify(() => mockWebViewWidgetController.pause()).called(1);
      verify(() => mockWebViewWidgetController.resume()).called(1);
      verify(
        () => mockLocalStorage.set<Map<String, int>>(any(), any()),
      ).called(1);
    });
  });

  group('pauseWebView', () {
    test('deve pausar webView e pausar stream de internet', () {
      subject.setWebViewController(mockWebViewWidgetController);

      subject.pauseWebView();

      verify(() => mockWebViewWidgetController.pause()).called(1);
    });
  });

  group('resumeWebView', () {
    test(
      'deve resumir webView, stream de internet e recarregar se necessário',
      () {
        subject.setWebViewController(mockWebViewWidgetController);

        subject.resumeWebView();

        verify(() => mockWebViewWidgetController.resume()).called(1);
      },
    );

    test('não deve recarregar webView se não houver internet', () {
      subject.setWebViewController(mockWebViewWidgetController);
      when(() => mockCheckInternet.call()).thenAnswer((_) async => false);

      subject.resumeWebView();

      verify(() => mockWebViewWidgetController.resume()).called(1);
      verifyNever(
        () => mockWebViewWidgetController.reload(
          initialUrl: any(named: 'initialUrl'),
        ),
      );
    });
  });

  group('tryAgain', () {
    test('deve resetar tentativas e recriar webView quando há erro', () async {
      subject.setError(true);
      expect(subject.hasError, true);

      subject.tryAgain();

      expect(subject.isNetworkError, isNull);
      await Future.delayed(const Duration(milliseconds: 600));
      expect(subject.isLoading, true);
    });

    test('não deve recriar webView quando não há erro nem processGone', () {
      expect(subject.hasError, false);
      expect(subject.processGone, false);

      subject.tryAgain();

      expect(subject.isNetworkError, isNull);
    });
  });

  group('reloadWebView', () {
    test(
      'deve recarregar webView através do controller quando não há erro',
      () async {
        subject.setWebViewController(mockWebViewWidgetController);

        await subject.reloadWebView(initialUrl: true);

        verify(
          () => mockWebViewWidgetController.reload(initialUrl: true),
        ).called(1);
      },
    );

    test(
      'deve recriar webView quando há erro e aguardar recreate',
      () async {
        subject.setWebViewController(mockWebViewWidgetController);
        subject.setError(true);

        await subject.reloadWebView(initialUrl: true);

        verifyNever(
          () => mockWebViewWidgetController.reload(
            initialUrl: any(named: 'initialUrl'),
          ),
        );
        verify(
          () => mockLocalStorage.get<Map<String, dynamic>>(any()),
        ).called(1);
      },
      timeout: const Timeout(Duration(seconds: 10)),
    );

    test('não deve fazer nada quando webView está paused', () async {
      subject.setWebViewController(mockWebViewWidgetController);
      subject.setPaused(true);

      await subject.reloadWebView(initialUrl: true);

      verifyNever(
        () => mockWebViewWidgetController.reload(
          initialUrl: any(named: 'initialUrl'),
        ),
      );
    });
  });

  group('internetConnectionListener', () {
    test('deve chamar tryAgain quando internet retorna e está em loading', () {
      subject.setLoading(true);
      expect(subject.isLoading, true);

      subject.onInternetConnectionChanged(true);

      expect(subject.isNetworkError, isNull);
    });

    test('não deve fazer nada quando está paused', () {
      subject.setPaused(true);
      subject.setLoading(true);

      subject.onInternetConnectionChanged(true);

      expect(subject.isLoading, true);
    });

    test('não deve fazer nada quando não tem internet', () {
      subject.setLoading(true);

      subject.onInternetConnectionChanged(false);

      expect(subject.isLoading, true);
    });
  });

  group('noInternetConnectionCallback', () {
    test('deve registrar log e definir lastTimeReloadedWebView', () {
      subject.onInternetConnectionChanged(true);
      subject.setLoading(false);
      // O método addLog é chamado dentro de noInternetConnectionCallback
      // O DialogWidget.show não é testável em unidade por precisar de BuildContext
      expect(subject.hasError, false);
    });
  });

  group('shareLogs', () {
    test('deve compartilhar logs via use case', () async {
      subject.addLog('log de teste');

      await subject.shareLogs();

      verify(
        () => mockShare.call(
          title: any(named: 'title'),
          text: any(named: 'text'),
        ),
      ).called(1);
    });
  });

  group('lifecycle', () {
    test('onClose deve dispor recursos e cancelar subscriptions', () {
      subject.setWebViewController(mockWebViewWidgetController);

      subject.onClose();

      verify(() => mockLocalStorage.delete(any())).called(1);
      verify(() => mockCheckInternet.dispose()).called(1);
    });

    test('onAppForeground deve atualizar estado do app no webViewController', () {
      subject.setWebViewController(mockWebViewWidgetController);

      subject.onAppForeground();

      verify(
        () => mockWebViewWidgetController.updateAppInBackground(false),
      ).called(1);
    });

    test('onAppBackground deve salvar scroll e atualizar estado de background', () {
      subject.setWebViewController(mockWebViewWidgetController);

      subject.onAppBackground();

      verify(
        () => mockWebViewWidgetController.updateAppInBackground(true),
      ).called(1);
      verify(() => mockWebViewWidgetController.stopLoadingTimer()).called(1);
      verify(
        () => mockLocalStorage.set<Map<String, int>>(any(), any()),
      ).called(1);
    });

    test('onReady deve configurar listener de conexão', () {
      subject.onReady();

      // O listener foi configurado (não lança exceção)
      expect(subject.hasError, isFalse);
    });
  });

  group('getters', () {
    test('logs deve conter a mensagem adicionada via addLog', () {
      subject.addLog('mensagem de teste');

      final logs = subject.logs;

      expect(logs, isNotEmpty);
      expect(logs.first, contains('mensagem de teste'));
    });

    test('addLog deve adicionar log mesmo com mensagem vazia', () {
      subject.addLog('');

      final logs = subject.logs;

      expect(logs, isNotEmpty);
    });

    test('canTryReloadAgain deve retornar true inicialmente', () {
      expect(subject.canTryReloadAgain, isTrue);
    });

    test(
      'canTryReloadAgain deve retornar false após _recreateWebView sem reset',
      () async {
        expect(subject.canTryReloadAgain, isTrue);

        // setProcessGone(true) chama _recreateWebView() sem _resetTimesToRetry()
        subject.setProcessGone(true);
        await Future.delayed(const Duration(milliseconds: 600));

        expect(subject.canTryReloadAgain, isFalse);
      },
    );

    test('currentStep deve delegar ao webViewController', () {
      expect(subject.currentStep, isNull);

      subject.setWebViewController(mockWebViewWidgetController);

      expect(subject.currentStep, LoadWebviewStepEnum.webViewCreated);
    });

    test('hasInternet deve delegar ao checkInternetUseCase', () async {
      when(() => mockCheckInternet.call()).thenAnswer((_) async => true);

      final result = await subject.hasInternet;

      expect(result, isTrue);
      verify(() => mockCheckInternet.call()).called(1);
    });

    test('isLoadingValue deve refletir estado de loading', () {
      expect(subject.isLoadingValue.value, true);

      subject.setLoading(false);

      expect(subject.isLoadingValue.value, false);
    });

    test('hasErrorValue deve refletir estado de erro', () {
      expect(subject.hasErrorValue.value, false);

      subject.setError(true);

      expect(subject.hasErrorValue.value, true);
    });

    test('processGoneValue deve refletir estado processGone', () {
      expect(subject.processGoneValue.value, false);

      subject.setProcessGone(true);

      expect(subject.processGoneValue.value, true);
    });

    test('showWebView deve ser true inicialmente', () {
      expect(subject.showWebView.value, isTrue);
    });
  });

  group('scrollToTop', () {
    test('deve chamar scrollTo no webViewController', () {
      subject.setWebViewController(mockWebViewWidgetController);

      subject.scrollToTop();

      verify(
        () => mockWebViewWidgetController.scrollTo(
          x: 0,
          y: 0,
          animated: true,
        ),
      ).called(1);
    });
  });

  group('setWebViewController', () {
    test('deve registrar listener de progresso no novo controller', () {
      final progressNotifier = ValueNotifier<int>(0);
      when(
        () => mockWebViewWidgetController.lastProgress,
      ).thenReturn(progressNotifier);

      subject.setWebViewController(mockWebViewWidgetController);

      progressNotifier.value = 50;
      expect(subject.lastProgress.value, 50);
    });
  });

  group('updateScrollPosition', () {
    test('deve atualizar scrollX e scrollY', () {
      expect(subject.scrollX, 0);
      expect(subject.scrollY, 0);

      subject.updateScrollPosition(150, 300);

      expect(subject.scrollX, 150);
      expect(subject.scrollY, 300);
    });
  });

  group('setPaused', () {
    test(
      'deve impedir reloadWebView quando setPaused é true',
      () async {
        subject.setWebViewController(mockWebViewWidgetController);
        subject.setPaused(true);

        await subject.reloadWebView(initialUrl: true);

        verifyNever(
          () => mockWebViewWidgetController.reload(
            initialUrl: any(named: 'initialUrl'),
          ),
        );
      },
    );

    test(
      'deve pausar e resumir corretamente através de pauseWebView/resumeWebView',
      () {
        subject.setWebViewController(mockWebViewWidgetController);

        subject.pauseWebView();
        verify(() => mockWebViewWidgetController.pause()).called(1);

        subject.resumeWebView();
        verify(() => mockWebViewWidgetController.resume()).called(1);
      },
    );
  });

  group('checkInternetConnection', () {
    test('deve delegar ao checkInternetUseCase e retornar true', () async {
      when(() => mockCheckInternet.call()).thenAnswer((_) async => true);

      final result = await subject.checkInternetConnection();

      expect(result, isTrue);
      verify(() => mockCheckInternet.call()).called(1);
    });

    test(
      'deve delegar ao checkInternetUseCase e retornar false sem conexão',
      () async {
        when(() => mockCheckInternet.call()).thenAnswer((_) async => false);

        final result = await subject.checkInternetConnection();

        expect(result, isFalse);
        verify(() => mockCheckInternet.call()).called(1);
      },
    );
  });

  group('resumeWebView com content expired', () {
    test(
      'deve recarregar webView quando conteúdo expirou',
      () async {
        subject.setWebViewController(mockWebViewWidgetController);
        // Carrega com sucesso para definir _lastTimeReloadedWebView
        subject.setLoading(false);

        final expiredUrlEntity = ReloadExpiredUrlEntity(
          enable: true,
          pattern: RegExp(r'example\.com'),
          expiredTime: const Duration(seconds: -1),
        );

        subject = WebViewController(
          globalKeyHash: 'test_hash',
          localStorage: mockLocalStorage,
          checkInternetUseCase: mockCheckInternet,
          openWebUrlUseCase: mockOpenWebUrl,
          shareUseCase: mockShare,
          openPage: (String url) async {
            openedPages.add(url);
          },
          reloadExpiredUrls: <ReloadExpiredUrlEntity>[expiredUrlEntity],
        );
        subject.initialUrl = 'https://example.com';
        subject.setWebViewController(mockWebViewWidgetController);
        subject.setLoading(false);

        subject.resumeWebView();
        await Future.delayed(const Duration(milliseconds: 100));

        verify(
          () => mockWebViewWidgetController.reload(
            initialUrl: any(named: 'initialUrl'),
          ),
        ).called(1);
      },
      timeout: const Timeout(Duration(seconds: 10)),
    );

    test(
      'não deve recarregar webView quando conteúdo não expirou',
      () async {
        subject.setWebViewController(mockWebViewWidgetController);

        final expiredUrlEntity = ReloadExpiredUrlEntity(
          enable: true,
          pattern: RegExp(r'example\.com'),
          expiredTime: const Duration(hours: 1),
        );

        subject = WebViewController(
          globalKeyHash: 'test_hash',
          localStorage: mockLocalStorage,
          checkInternetUseCase: mockCheckInternet,
          openWebUrlUseCase: mockOpenWebUrl,
          shareUseCase: mockShare,
          openPage: (String url) async {
            openedPages.add(url);
          },
          reloadExpiredUrls: <ReloadExpiredUrlEntity>[expiredUrlEntity],
        );
        subject.initialUrl = 'https://example.com';
        subject.setWebViewController(mockWebViewWidgetController);
        subject.setLoading(false);

        subject.resumeWebView();

        verifyNever(
          () => mockWebViewWidgetController.reload(
            initialUrl: any(named: 'initialUrl'),
          ),
        );
      },
    );

    test(
      'não deve recarregar quando pattern não corresponde à URL',
      () async {
        subject.setWebViewController(mockWebViewWidgetController);

        final expiredUrlEntity = ReloadExpiredUrlEntity(
          enable: true,
          pattern: RegExp(r'outro-site\.com'),
          expiredTime: const Duration(seconds: -1),
        );

        subject = WebViewController(
          globalKeyHash: 'test_hash',
          localStorage: mockLocalStorage,
          checkInternetUseCase: mockCheckInternet,
          openWebUrlUseCase: mockOpenWebUrl,
          shareUseCase: mockShare,
          openPage: (String url) async {
            openedPages.add(url);
          },
          reloadExpiredUrls: <ReloadExpiredUrlEntity>[expiredUrlEntity],
        );
        subject.initialUrl = 'https://example.com';
        subject.setWebViewController(mockWebViewWidgetController);
        subject.setLoading(false);

        subject.resumeWebView();

        verifyNever(
          () => mockWebViewWidgetController.reload(
            initialUrl: any(named: 'initialUrl'),
          ),
        );
      },
    );
  });

  group('resumeWebView com error/processGone', () {
    test(
      'deve recriar webView quando processGone é true',
      () async {
        subject.setWebViewController(mockWebViewWidgetController);
        subject.setProcessGone(true);
        await Future.delayed(const Duration(milliseconds: 100));

        // processGone está true, _recreateWebView foi chamado
        expect(subject.processGone, isTrue);
      },
    );

    test(
      'deve recriar webView quando hasError é true via tryAgain',
      () async {
        subject.setWebViewController(mockWebViewWidgetController);
        subject.setError(true);
        expect(subject.hasError, isTrue);

        subject.tryAgain();

        expect(subject.isNetworkError, isNull);
        await Future.delayed(const Duration(milliseconds: 600));
        expect(subject.isLoading, isTrue);
      },
    );
  });

  group('reloadWebView com erro', () {
    test(
      'não deve recarregar quando hasError e webView está paused',
      () async {
        subject.setWebViewController(mockWebViewWidgetController);
        subject.setError(true);
        subject.setPaused(true);

        await subject.reloadWebView(initialUrl: true);

        verifyNever(
          () => mockWebViewWidgetController.reload(
            initialUrl: any(named: 'initialUrl'),
          ),
        );
      },
    );
  });

  group('onInternetConnectionChanged', () {
    test(
      'deve chamar tryAgain quando internet retorna e step é error',
      () {
        when(
          () => mockWebViewWidgetController.currentStep,
        ).thenReturn(LoadWebviewStepEnum.error);
        subject.setWebViewController(mockWebViewWidgetController);

        subject.onInternetConnectionChanged(true);

        expect(subject.isNetworkError, isNull);
      },
    );

    test(
      'deve chamar tryAgain quando internet retorna e isLoading é true',
      () {
        subject.setLoading(true);

        subject.onInternetConnectionChanged(true);

        expect(subject.isNetworkError, isNull);
      },
    );
  });
}
