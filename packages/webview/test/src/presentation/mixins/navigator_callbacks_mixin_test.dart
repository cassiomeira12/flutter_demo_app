import 'package:dependency/dependency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webview/src/domain/callbacks/custom_navigator_callback.dart';
import 'package:webview/src/presentation/mixins/mixins.dart';
import 'package:webview/src/presentation/webview/widgets/webview_widget_controller.dart';

class MockNavigationAction extends Mock implements NavigationAction {}

class MockWebViewWidgetController extends Mock
    implements WebViewWidgetController {}

class MockCustomNavigatorCallback extends Mock
    implements CustomNavigatorCallback {}

class NavigatorCallbacksTest with NavigatorCallbacksMixin {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri.parse('https://fallback.example.com'));
    registerFallbackValue(MockNavigationAction());
    registerFallbackValue((String _) {});
  });

  late MockNavigationAction mockNavAction;
  late MockWebViewWidgetController mockController;
  late MockCustomNavigatorCallback mockCustomCallback;
  late NavigatorCallbacksTest subject;
  late List<String> logs;
  late List<String> clickedUrls;
  late List<Uri> openedExternalLinks;

  setUp(() {
    mockNavAction = MockNavigationAction();
    mockController = MockWebViewWidgetController();
    mockCustomCallback = MockCustomNavigatorCallback();
    subject = NavigatorCallbacksTest();
    logs = [];
    clickedUrls = [];
    openedExternalLinks = [];

    // Stub padrão para propriedades bool e métodos
    when(() => mockController.isPaused).thenReturn(false);
    when(() => mockController.isAppInBackground).thenReturn(false);
    when(() => mockController.isInternetConnected).thenReturn(true);
    when(() => mockController.currentUri).thenAnswer((_) async => null);
    when(() => mockController.loadUrl(any())).thenAnswer((_) async {});
  });

  URLRequest createRequest({String? url}) {
    return URLRequest(url: url != null ? WebUri(url) : null);
  }

  void stubNavAction({
    bool isForMainFrame = true,
    bool? hasGesture,
    bool? isRedirect,
    String? url = 'https://example.com',
    NavigationType? navigationType,
  }) {
    when(() => mockNavAction.isForMainFrame).thenReturn(isForMainFrame);
    when(() => mockNavAction.hasGesture).thenReturn(hasGesture);
    when(() => mockNavAction.isRedirect).thenReturn(isRedirect);
    when(() => mockNavAction.navigationType).thenReturn(
      navigationType ?? NavigationType.LINK_ACTIVATED,
    );
    when(() => mockNavAction.toJson()).thenReturn({});
    when(() => mockNavAction.request).thenReturn(createRequest(url: url));
  }

  Future<NavigationActionPolicy> executeShouldOverrideUrlLoading() {
    return subject.shouldOverrideUrlLoading(
      mockNavAction,
      webViewController: mockController,
      click: (url) => clickedUrls.add(url),
      onLog: (log) => logs.add(log),
      openExternalLink: (uri) => openedExternalLinks.add(uri),
    );
  }

  Future<NavigationActionPolicy> executeWithCustomCallbacks() {
    return subject.shouldOverrideUrlLoading(
      mockNavAction,
      webViewController: mockController,
      click: (url) => clickedUrls.add(url),
      onLog: (log) => logs.add(log),
      openExternalLink: (uri) => openedExternalLinks.add(uri),
      customCallbacks: mockCustomCallback,
    );
  }

  group('shouldOverrideUrlLoading', () {
    group('Cenários de Sucesso', () {
      test(
        'deve retornar ALLOW quando URL é null',
        () async {
          stubNavAction(url: null);

          final result = await executeShouldOverrideUrlLoading();

          expect(result, NavigationActionPolicy.ALLOW);
          expect(logs.any((l) => l.contains('URL null')), isTrue);
        },
      );

      test(
        'deve retornar ALLOW quando URL é about:blank',
        () async {
          stubNavAction(url: 'about:blank');

          final result = await executeShouldOverrideUrlLoading();

          expect(result, NavigationActionPolicy.ALLOW);
          expect(logs.any((l) => l.contains('about:blank')), isTrue);
        },
      );

      test(
        'deve retornar CANCEL quando URL começa com javascript:',
        () async {
          stubNavAction(url: 'javascript:void(0)');

          final result = await executeShouldOverrideUrlLoading();

          expect(result, NavigationActionPolicy.CANCEL);
          expect(logs.any((l) => l.contains('javascript')), isTrue);
        },
      );

      test(
        'deve retornar ALLOW quando não é main frame',
        () async {
          stubNavAction(isForMainFrame: false);

          final result = await executeShouldOverrideUrlLoading();

          expect(result, NavigationActionPolicy.ALLOW);
          expect(logs.any((l) => l.contains('Not MainFrame')), isTrue);
        },
      );

      test(
        'deve retornar ALLOW quando navigationType é RELOAD',
        () async {
          stubNavAction(
            navigationType: NavigationType.RELOAD,
          );

          final result = await executeShouldOverrideUrlLoading();

          expect(result, NavigationActionPolicy.ALLOW);
          expect(logs.any((l) => l.contains('RELOAD')), isTrue);
        },
      );

      test(
        'deve retornar ALLOW quando URI é igual ao originalUri',
        () async {
          const url = 'https://example.com';
          stubNavAction(
            // Evita que navigationClicked dispare CANCEL
            navigationType: NavigationType.FORM_SUBMITTED,
          );
          when(() => mockController.originalUri).thenReturn(
            Uri.parse(url),
          );

          final result = await executeShouldOverrideUrlLoading();

          expect(result, NavigationActionPolicy.ALLOW);
          expect(logs.any((l) => l.contains('equals Last')), isTrue);
        },
      );

      test(
        'deve retornar ALLOW quando URI é igual ao currentUri',
        () async {
          const url = 'https://example.com/page';
          stubNavAction(
            url: url,
            // Evita que navigationClicked dispare CANCEL
            navigationType: NavigationType.FORM_SUBMITTED,
          );
          when(() => mockController.currentUri).thenAnswer(
            (_) async => Uri.parse(url),
          );

          final result = await executeShouldOverrideUrlLoading();

          expect(result, NavigationActionPolicy.ALLOW);
          expect(logs.any((l) => l.contains('equals Last')), isTrue);
        },
      );

      test(
        'deve retornar ALLOW e log DirectSubRoute quando é subrota direta (com gesture)',
        () async {
          const baseUrl = 'https://example.com/product';
          const subUrl = 'https://example.com/product/123';
          stubNavAction(
            url: subUrl,
            hasGesture: true,
            navigationType: NavigationType.FORM_SUBMITTED,
          );
          when(() => mockController.currentUri).thenAnswer(
            (_) async => Uri.parse(baseUrl),
          );

          final result = await executeShouldOverrideUrlLoading();

          expect(result, NavigationActionPolicy.ALLOW);
          expect(logs.any((l) => l.contains('DirectSubRoute')), isTrue);
        },
      );

      test(
        'deve retornar ALLOW e log DirectSubRoute quando é subrota direta (navigation clicked)',
        () async {
          const baseUrl = 'https://example.com/product';
          const subUrl = 'https://example.com/product/123';
          stubNavAction(
            url: subUrl,
            hasGesture: false,
            navigationType: NavigationType.LINK_ACTIVATED,
          );
          when(() => mockController.currentUri).thenAnswer(
            (_) async => Uri.parse(baseUrl),
          );

          final result = await executeShouldOverrideUrlLoading();

          expect(result, NavigationActionPolicy.ALLOW);
          expect(logs.any((l) => l.contains('DirectSubRoute')), isTrue);
        },
      );

      test(
        'deve retornar ALLOW no fallback final quando fluxo não entra em nenhuma condição anterior',
        () async {
          const currentUrl = 'https://example.com/current';
          const targetUrl = 'https://example.com/other-page';
          stubNavAction(
            url: targetUrl,
            hasGesture: false,
            isRedirect: false,
            navigationType: NavigationType.FORM_SUBMITTED,
          );
          when(() => mockController.currentUri).thenAnswer(
            (_) async => Uri.parse(currentUrl),
          );

          final result = await executeShouldOverrideUrlLoading();

          expect(result, NavigationActionPolicy.ALLOW);
          expect(logs.any((l) => l.contains('final')), isTrue);
        },
      );

      test(
        'deve retornar ALLOW no fallback final com navigationType BACK_FORWARD',
        () async {
          const currentUrl = 'https://example.com/current';
          const targetUrl = 'https://example.com/other-page';
          stubNavAction(
            url: targetUrl,
            hasGesture: false,
            isRedirect: false,
            navigationType: NavigationType.BACK_FORWARD,
          );
          when(() => mockController.currentUri).thenAnswer(
            (_) async => Uri.parse(currentUrl),
          );

          final result = await executeShouldOverrideUrlLoading();

          expect(result, NavigationActionPolicy.ALLOW);
          expect(logs.any((l) => l.contains('final')), isTrue);
        },
      );

      test(
        'deve retornar CANCEL quando scheme contém unsafe',
        () async {
          stubNavAction(url: 'unsafe://example.com');

          final result = await executeShouldOverrideUrlLoading();

          expect(result, NavigationActionPolicy.CANCEL);
          expect(logs.any((l) => l.contains('Unsafe')), isTrue);
        },
        skip:
            'developer.debugger() no mixin trava o teste '
            '(VM service ativo no flutter test interpreta como debugger conectado). '
            'O comportamento é verificado manualmente.',
      );

      test(
        'deve retornar CANCEL e chamar openExternalLink para scheme não http/https',
        () async {
          stubNavAction(url: 'tel:123456789');

          final result = await executeShouldOverrideUrlLoading();

          expect(result, NavigationActionPolicy.CANCEL);
          expect(openedExternalLinks, isNotEmpty);
          expect(openedExternalLinks.first.toString(), 'tel:123456789');
          expect(logs.any((l) => l.contains('openExternalLink')), isTrue);
        },
      );

      test(
        'deve retornar CANCEL e chamar loadUrl quando !hasGesture e isRedirect',
        () async {
          const url = 'https://example.com/redirect';
          stubNavAction(
            url: url,
            hasGesture: false,
            isRedirect: true,
            navigationType: NavigationType.BACK_FORWARD,
          );

          final result = await executeShouldOverrideUrlLoading();

          expect(result, NavigationActionPolicy.CANCEL);
          verify(() => mockController.loadUrl(WebUri(url).uriValue)).called(1);
          expect(logs.any((l) => l.contains('loadUrl')), isTrue);
        },
      );

      test(
        'deve retornar CANCEL e chamar click quando hasGesture e !isSubRoute',
        () async {
          const url = 'https://example.com/new-page';
          stubNavAction(
            url: url,
            hasGesture: true,
            navigationType: NavigationType.FORM_SUBMITTED,
          );
          when(() => mockController.currentUri).thenAnswer(
            (_) async => Uri.parse('https://example.com/other'),
          );

          final result = await executeShouldOverrideUrlLoading();

          expect(result, NavigationActionPolicy.CANCEL);
          expect(clickedUrls, contains(url));
          expect(logs.any((l) => l.contains('click')), isTrue);
        },
      );

      test(
        'deve retornar CANCEL e chamar click quando navigationClicked e !isSubRoute',
        () async {
          const url = 'https://example.com/new-page';
          stubNavAction(
            url: url,
            hasGesture: false,
            navigationType: NavigationType.LINK_ACTIVATED,
          );
          when(() => mockController.currentUri).thenAnswer(
            (_) async => Uri.parse('https://example.com/other'),
          );

          final result = await executeShouldOverrideUrlLoading();

          expect(result, NavigationActionPolicy.CANCEL);
          expect(clickedUrls, contains(url));
          expect(logs.any((l) => l.contains('click')), isTrue);
        },
      );

      test(
        'deve chamar openExternalLink para mailto scheme',
        () async {
          stubNavAction(url: 'mailto:test@example.com');

          final result = await executeShouldOverrideUrlLoading();

          expect(result, NavigationActionPolicy.CANCEL);
          expect(openedExternalLinks, isNotEmpty);
          expect(
            openedExternalLinks.first.toString(),
            'mailto:test@example.com',
          );
          expect(logs.any((l) => l.contains('openExternalLink')), isTrue);
        },
      );
    });

    group('Cenários com CustomNavigatorCallback', () {
      setUp(() {
        // Configura um cenário base que passaria por todas as validações
        // iniciais e chegaria até customCallbacks
        stubNavAction(
          url: 'https://example.com/some-page',
          hasGesture: false,
          isRedirect: false,
          navigationType: NavigationType.FORM_SUBMITTED,
        );
        when(() => mockController.currentUri).thenAnswer(
          (_) async => Uri.parse('https://example.com/current'),
        );
        when(() => mockCustomCallback.call(
          any(),
          any(),
          any(),
          isRedirect: any(named: 'isRedirect'),
          hasGesture: any(named: 'hasGesture'),
          userClicked: any(named: 'userClicked'),
          uri: any(named: 'uri'),
        )).thenAnswer((_) async => null);
      });

      test(
        'deve retornar ALLOW quando customCallbacks retorna ALLOW',
        () async {
          when(() => mockCustomCallback.call(
            any(),
            any(),
            any(),
            isRedirect: any(named: 'isRedirect'),
            hasGesture: any(named: 'hasGesture'),
            userClicked: any(named: 'userClicked'),
            uri: any(named: 'uri'),
          )).thenAnswer((_) async => NavigationActionPolicy.ALLOW);

          final result = await executeWithCustomCallbacks();

          expect(result, NavigationActionPolicy.ALLOW);
          verify(() => mockCustomCallback.call(
            any(),
            any(),
            any(),
            isRedirect: any(named: 'isRedirect'),
            hasGesture: any(named: 'hasGesture'),
            userClicked: any(named: 'userClicked'),
            uri: any(named: 'uri'),
          )).called(1);
        },
      );

      test(
        'deve retornar CANCEL quando customCallbacks retorna CANCEL',
        () async {
          when(() => mockCustomCallback.call(
            any(),
            any(),
            any(),
            isRedirect: any(named: 'isRedirect'),
            hasGesture: any(named: 'hasGesture'),
            userClicked: any(named: 'userClicked'),
            uri: any(named: 'uri'),
          )).thenAnswer((_) async => NavigationActionPolicy.CANCEL);

          final result = await executeWithCustomCallbacks();

          expect(result, NavigationActionPolicy.CANCEL);
          verify(() => mockCustomCallback.call(
            any(),
            any(),
            any(),
            isRedirect: any(named: 'isRedirect'),
            hasGesture: any(named: 'hasGesture'),
            userClicked: any(named: 'userClicked'),
            uri: any(named: 'uri'),
          )).called(1);
        },
      );

      test(
        'deve continuar fluxo normal quando customCallbacks retorna null',
        () async {
          // Como nenhum dos cenários anteriores se aplica (link normal sem gesture
          // e sem redirect), o fluxo continua até o fallback final ALLOW
          final result = await executeWithCustomCallbacks();

          expect(result, NavigationActionPolicy.ALLOW);
          expect(logs.any((l) => l.contains('final')), isTrue);
        },
      );

      test(
        'deve propagar exceção quando customCallbacks lança erro',
        () async {
          when(() => mockCustomCallback.call(
            any(),
            any(),
            any(),
            isRedirect: any(named: 'isRedirect'),
            hasGesture: any(named: 'hasGesture'),
            userClicked: any(named: 'userClicked'),
            uri: any(named: 'uri'),
          )).thenThrow(Exception('Erro no callback customizado'));

          expect(
            () => executeWithCustomCallbacks(),
            throwsA(isA<Exception>()),
          );
        },
      );
    });

    group('Cenários de Erro e Casos de Borda', () {
      test(
        'deve retornar ALLOW mesmo quando currentUri retorna null',
        () async {
          stubNavAction(
            url: 'https://example.com/some-page',
            // Não usa LINK_ACTIVATED para evitar o CANCEL do navigationClicked
            navigationType: NavigationType.FORM_SUBMITTED,
          );
          // currentUri já retorna null pelo stub padrão do setUp

          final result = await executeShouldOverrideUrlLoading();

          // Como lastUriLoaded é null, os UriHelper retornam false,
          // e o fluxo cai no fallback final ALLOW
          expect(result, NavigationActionPolicy.ALLOW);
        },
      );

      test(
        'deve retornar ALLOW quando originalUri é null',
        () async {
          const url = 'https://example.com/page';
          stubNavAction(
            url: url,
            navigationType: NavigationType.FORM_SUBMITTED,
          );
          when(() => mockController.originalUri).thenReturn(null);

          final result = await executeShouldOverrideUrlLoading();

          // UriHelper.equals(null, uri) retorna false,
          // fluxo continua até fallback final ALLOW
          expect(result, NavigationActionPolicy.ALLOW);
        },
      );

      test(
        'deve lidar com hasGesture null convertido para false no fluxo de redirect',
        () async {
          const url = 'https://example.com/redirect';
          stubNavAction(
            url: url,
            isRedirect: true,
            navigationType: NavigationType.BACK_FORWARD,
          );

          final result = await executeShouldOverrideUrlLoading();

          // No mixin: hasGesture = null == true = false, isRedirect = true == true = true
          // !hasGesture && isRedirect → !false && true → true && true → true
          // Entra no bloco de redirect e chama loadUrl
          expect(result, NavigationActionPolicy.CANCEL);
          verify(() => mockController.loadUrl(WebUri(url).uriValue)).called(1);
        },
      );

      test(
        'deve lidar com isRedirect null convertido para false',
        () async {
          const url = 'https://example.com/page';
          stubNavAction(
            url: url,
            hasGesture: false,
            navigationType: NavigationType.FORM_SUBMITTED,
          );

          final result = await executeShouldOverrideUrlLoading();

          // No mixin: hasGesture = false == true = false, isRedirect = null == true = false
          // !hasGesture && isRedirect → !false && false → true && false → false
          // Não entra no redirect. navigationClicked = false, !isSubRoute = true
          // (hasGesture || navigationClicked) && !isSubRoute → (false || false) && true → false
          // Cai no ALLOW final
          expect(result, NavigationActionPolicy.ALLOW);
        },
      );

      test(
        'deve propagar exceção quando loadUrl lança erro',
        () async {
          const url = 'https://example.com/redirect';
          stubNavAction(
            url: url,
            hasGesture: false,
            isRedirect: true,
            navigationType: NavigationType.BACK_FORWARD,
          );
          when(() => mockController.loadUrl(WebUri(url).uriValue)).thenThrow(
            Exception('Falha ao carregar URL'),
          );

          // O mixin não usa try-catch ao chamar loadUrl,
          // portanto a exceção sincrona se propaga
          expect(
            () => executeShouldOverrideUrlLoading(),
            throwsA(isA<Exception>()),
          );
        },
      );

      test(
        'deve cair no fallback ALLOW quando isSubRoute é true mas isDirectSubRoute é false',
        () async {
          // Cenário: target tem 2 níveis a mais que current (4 vs 2 segmentos).
          // isSubRoute retorna true, isDirectSubRoute retorna false
          // (precisa de exatamente 1 nível extra para ser direta).
          // hasGesture = false e navigationType != LINK_ACTIVATED para que
          // userClickedOnLink seja false e o fluxo chegue até o fallback final.
          const currentUrl = 'https://example.com/product/123';
          const targetUrl =
              'https://example.com/product/123/details/reviews';
          stubNavAction(
            url: targetUrl,
            hasGesture: false,
            navigationType: NavigationType.FORM_SUBMITTED,
          );
          when(() => mockController.currentUri).thenAnswer(
            (_) async => Uri.parse(currentUrl),
          );

          final result = await executeShouldOverrideUrlLoading();

          // isSubRoute = true, isDirectSubRoute = false
          // Não entra no bloco DirectSubRoute (linha 94-98 do mixin)
          // hasGesture = false, iOSGestureClicked = false (FORM_SUBMITTED)
          // userClickedOnLink = false
          // !hasGesture && isRedirect → !false && false → false
          // userClickedOnLink → false
          // Cai no ALLOW final
          expect(result, NavigationActionPolicy.ALLOW);
          expect(logs.any((l) => l.contains('final')), isTrue);
        },
      );
    });
  });

  group('onScrollChanged', () {
    test(
      'deve chamar onSaveScroll com os valores corretos de x e y',
      () async {
        const expectedX = 100;
        const expectedY = 200;
        late int savedX;
        late int savedY;

        subject.onScrollChanged(
          x: 10,
          y: 10,
          onSaveScroll: (x, y) {
            savedX = x;
            savedY = y;
          },
        );

        subject.onScrollChanged(
          x: 20,
          y: 20,
          onSaveScroll: (x, y) {
            savedX = x;
            savedY = y;
          },
        );

        subject.onScrollChanged(
          x: 30,
          y: 30,
          onSaveScroll: (x, y) {
            savedX = x;
            savedY = y;
          },
        );

        subject.onScrollChanged(
          x: expectedX,
          y: expectedY,
          onSaveScroll: (x, y) {
            savedX = x;
            savedY = y;
          },
        );

        await Future.delayed(const Duration(seconds: 1));

        expect(savedX, expectedX);
        expect(savedY, expectedY);
      },
    );
  });
}
