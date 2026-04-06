import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:webview/src/presentation/widgets/web_view/webview_widget_controller.dart';

mixin NavigatorCallbacksExtension {
  Future<NavigationActionPolicy?> shouldOverrideUrlLoading(
    InAppWebViewController controller,
    NavigationAction navAction, {
    required WebViewWidgetController webViewController,
    required void Function(String url) click,
    required void Function(String log) onLog,
    required void Function(Uri uri) openExternalLink,
  }) async {
    final Uri? lastUriLoaded = await webViewController.currentUri;
    final WebUri? uri = navAction.request.url;

    // não carregar sem url ou url about:blank
    if (uri == null || uri.toString() == 'about:blank') {
      return NavigationActionPolicy.CANCEL;
    }

    final String url = uri.toString();

    // aceita carregamento de scripts no iOS
    if (!navAction.isForMainFrame) {
      return NavigationActionPolicy.ALLOW;
    }

    // aceita ação de reload da pagina
    if (navAction.navigationType == NavigationType.RELOAD) {
      return NavigationActionPolicy.ALLOW;
    }

    // aceita carregamento se a url for a mesma atual
    if (lastUriLoaded?.toString() == url) {
      return NavigationActionPolicy.ALLOW;
    }

    // Ignore action when URL is unsafe
    if (uri.scheme.contains('unsafe')) {
      return NavigationActionPolicy.CANCEL;
    }

    // Custom Actions

    // trata urls com esquemas especiais
    if (!['http', 'https'].contains(uri.scheme)) {
      openExternalLink(uri);
      return NavigationActionPolicy.CANCEL;
    }

    final bool isForMainFrame = navAction.isForMainFrame;
    final bool hasNoGesture = navAction.hasGesture == false;
    final bool isRedirect = navAction.isRedirect == true;

    final String paramsLog = jsonEncode(navAction.toJson());

    if (isForMainFrame && hasNoGesture && isRedirect) {
      // ex: https://www.uol.com.br/esporte/mma
      onLog('shouldOverrideUrlLoading loadUrl $paramsLog');
      await controller.loadUrl(
        urlRequest: URLRequest(
          url: uri,
          mainDocumentURL: uri,
          cachePolicy: URLRequestCachePolicy.USE_PROTOCOL_CACHE_POLICY,
          // headers: (headers.isNotEmpty ? headers : null),
          allowsExpensiveNetworkAccess: true,
          allowsCellularAccess: true,
          httpShouldHandleCookies: true,
          networkServiceType: URLRequestNetworkServiceType.DEFAULT,
          httpShouldUsePipelining: true,
          allowsConstrainedNetworkAccess: true,
        ),
      );
      return NavigationActionPolicy.CANCEL;
    }

    onLog('shouldOverrideUrlLoading url: $url');

    if (Platform.isAndroid) {
      final action = await _androidShouldOverrideUrlLoading(
        navAction,
        click: click,
        onLog: onLog,
      );
      if (action != null) {
        return action;
      }
    }

    if (Platform.appleDevice) {
      final action = await _appleShouldOverrideUrlLoading(
        navAction,
        click: click,
        onLog: onLog,
      );
      if (action != null) {
        return action;
      }
    }

    // print('webview_widget $globalKeyHash lastUriLoaded: $lastUriLoaded');

    // if (lastUriLoaded != null && !uri.host.contains(lastUriLoaded.host)) {
    //   print(
    //     'webview_widget $globalKeyHash click ${lastUriLoaded.host} != ${uri.host}',
    //   );
    //   click(url);
    //   onLog('shouldOverrideUrlLoading click hosts $paramsLog');
    //   return NavigationActionPolicy.CANCEL;
    // }

    // if (url.contains(lastUriLoaded!.path)) {
    //   onLog('shouldOverrideUrlLoading contém msm path');
    //   return NavigationActionPolicy.ALLOW;
    // } else {
    //   click(url);
    //   return NavigationActionPolicy.CANCEL;
    // }

    onLog(
      'shouldOverrideUrlLoading final hasGesture: [${navAction.hasGesture}] navigationType: [${navAction.navigationType}] url: $url',
    );

    return NavigationActionPolicy.ALLOW;
  }

  Future<NavigationActionPolicy?> _androidShouldOverrideUrlLoading(
    NavigationAction navAction, {
    required void Function(String url) click,
    required void Function(String log) onLog,
  }) async {
    onLog('shouldOverrideUrlLoading Android');

    final String url = navAction.request.url.toString();

    // final bool isForMainFrame = navAction.isForMainFrame == true;
    final bool hasNoGesture = navAction.hasGesture == false;
    // final bool isNotRedirect = navAction.isRedirect == false;

    final int queryParams = navAction.request.url?.queryParameters.length ?? 0;
    final bool hasParams = queryParams > 1;
    // Se tiver mais de um parâmetro, permite carregar a url normalmente
    // Se tiver zero ou um parâmetro, considera que é um clique do usuário

    final String paramsLog = jsonEncode(navAction.toJson());

    if (!hasNoGesture && !hasParams) {
      click(url);
      onLog('shouldOverrideUrlLoading Android click $paramsLog');
      return NavigationActionPolicy.CANCEL;
    }

    onLog('shouldOverrideUrlLoading Android return null');
    return null;
  }

  Future<NavigationActionPolicy?> _appleShouldOverrideUrlLoading(
    NavigationAction navAction, {
    required void Function(String url) click,
    required void Function(String log) onLog,
  }) async {
    onLog('shouldOverrideUrlLoading Apple');

    final String url = navAction.request.url.toString();

    // final bool isForMainFrame = navAction.isForMainFrame == true;
    // final bool hasNoGesture = navAction.hasGesture == false;
    // final bool isNotRedirect = navAction.isRedirect == false;

    final int queryParams = navAction.request.url?.queryParameters.length ?? 0;
    final bool hasParams = queryParams > 1;
    // Se tiver mais de um parâmetro, permite carregar a url normalmente
    // Se tiver zero ou um parâmetro, considera que é um clique do usuário

    final String paramsLog = jsonEncode(navAction.toJson());

    final bool navigationClicked =
        navAction.navigationType == NavigationType.LINK_ACTIVATED;

    if (navigationClicked && !hasParams) {
      click(url);
      onLog('shouldOverrideUrlLoading Apple click $paramsLog');
      return NavigationActionPolicy.CANCEL;
    }

    onLog('shouldOverrideUrlLoading Apple return null');
    return null;
  }

  void onScrollChanged({
    required int x,
    required int y,
    required void Function(int x, int y) onSaveScroll,
  }) {
    onSaveScroll(x, y);
  }

  Future<ServerTrustAuthResponse?> onReceivedServerTrustAuthRequest(
    InAppWebViewController controller,
    URLAuthenticationChallenge challenge,
  ) async {
    return ServerTrustAuthResponse(
      action: ServerTrustAuthResponseAction.PROCEED,
    );
  }

  Future<ShouldAllowDeprecatedTLSAction?> shouldAllowDeprecatedTLS(
    InAppWebViewController controller,
    URLAuthenticationChallenge challenge,
  ) async {
    return ShouldAllowDeprecatedTLSAction.ALLOW;
  }
}
