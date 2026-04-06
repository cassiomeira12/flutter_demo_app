import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:webview/src/data/data.dart';
import 'package:webview/src/presentation/widgets/web_view/webview_widget_controller.dart';

class WebViewHeadless
    with
        LoadCallbacksExtension,
        NavigatorCallbacksExtension,
        ErrorCallbacksExtension {
  late WebViewWidgetController _webViewController;
  late HeadlessInAppWebView _headlessWebView;

  final Uri _uri;

  WebViewHeadless({
    required Uri uri,
  }) : _uri = uri {
    _createWebViewHeadless();
  }

  HeadlessInAppWebView get headlessWebView => _headlessWebView;

  Future<void> run() {
    _webViewController.startTrackPerformance(_uri);
    return _headlessWebView.run();
  }

  Future<void> loadUrl(Uri uri) {
    return _webViewController.loadUrl(uri);
  }

  void onLog(String log) {
    Log.info('WebView Headless - $log');
  }

  void loading(bool isLoading) {
    //
  }

  void processGone() {
    //
  }

  void onError({required bool isNetworkError, String? error}) {
    //
  }

  void _createWebViewHeadless() {
    _webViewController = WebViewWidgetControllerImpl(
      globalKeyHash: GlobalKey().toString(),
      uri: _uri,
      processGone: processGone,
      secondsToStartWebViewReload: 15, // widget.secondsToStartWebViewReload,
      loading: loading,
      onLog: onLog,
      checkInternet: () => Future.value(true),
      noInternetConnectionCallback: () {
        //
      },
    );

    _headlessWebView = HeadlessInAppWebView(
      initialSettings: InAppWebViewSettings(
        isInspectable: !kReleaseMode,
        // userAgent: widget.userAgent,
        allowsLinkPreview: false,
        allowsBackForwardNavigationGestures: false,
        allowsInlineMediaPlayback: Platform.appleDevice,
        disableDefaultErrorPage: true,
        verticalScrollBarEnabled: false,
        horizontalScrollBarEnabled: false,
        mediaPlaybackRequiresUserGesture: false,
        sharedCookiesEnabled: Platform.appleDevice,
        supportZoom: false,
        supportMultipleWindows: true,
        useOnLoadResource: true,
        useOnNavigationResponse: true,
        useOnRenderProcessGone: true,
        useShouldOverrideUrlLoading: true,
        underPageBackgroundColor: StaticColors.white,
      ),
      initialUrlRequest: URLRequest(url: WebUri.uri(_uri)),
      onWebViewCreated: (controller) {
        _webViewController.setInAppWebViewController(controller);
        // widget.onCreateController(_webViewController);
        return onWebViewCreated(
          null,
          webViewController: _webViewController,
          loading: loading,
          onLog: onLog,
        );
      },
      onLoadStart: (_, url) {
        return onLoadStart(
          url,
          webViewController: _webViewController,
          onLog: onLog,
        );
      },
      onProgressChanged: (_, progress) {
        return onProgressChanged(
          progress,
          webViewController: _webViewController,
          onLog: onLog,
        );
      },
      onPageCommitVisible: (_, url) {
        return onPageCommitVisible(
          url,
          webViewController: _webViewController,
          onLog: onLog,
          processGone: processGone,
        );
      },
      onLoadStop: (_, url) {
        return onLoadStop(
          url,
          webViewController: _webViewController,
          onLog: onLog,
          processGone: processGone,
        );
      },
      onReceivedError: (_, request, error) {
        return onReceivedError(
          request,
          error,
          webViewController: _webViewController,
          onError: onError,
          onLog: onLog,
        );
      },
      onReceivedHttpError: (_, request, errorResponse) {
        return onReceivedHttpError(
          request,
          errorResponse,
          webViewController: _webViewController,
          onError: onError,
          onLog: onLog,
          processGone: processGone,
        );
      },
      onRenderProcessGone: (_, detail) {
        _webViewController.setInAppWebViewController(null);
        return onRenderProcessGone(
          detail,
          webViewController: _webViewController,
          onLog: onLog,
          processGone: processGone,
        );
      },
      onWebContentProcessDidTerminate: (_) {
        _webViewController.setInAppWebViewController(null);
        return onWebContentProcessDidTerminate(
          webViewController: _webViewController,
          onLog: onLog,
          processGone: processGone,
        );
      },
      shouldOverrideUrlLoading: (controller, navigationAction) {
        if (_webViewController.isPaused) {
          onLog('shouldOverrideUrlLoading CANCEL [isPaused]');
          return Future.value(NavigationActionPolicy.CANCEL);
        }
        return shouldOverrideUrlLoading(
          controller,
          navigationAction,
          webViewController: _webViewController,
          click: (String url) {
            //
          },
          onLog: onLog,
          openExternalLink: (Uri uri) {
            //
          },
        );
      },
      onNavigationResponse: (_, _) {
        return Future.value(NavigationResponseAction.ALLOW);
      },
      onReceivedServerTrustAuthRequest: (controller, challenge) {
        return onReceivedServerTrustAuthRequest(controller, challenge);
      },
      onRenderProcessResponsive: (_, _) {
        onLog('onRenderProcessResponsive');
        return Future.value();
      },
      onRenderProcessUnresponsive: (_, _) {
        onLog('onRenderProcessUnresponsive');
        return Future.value();
      },
      shouldAllowDeprecatedTLS: (controller, challenge) {
        onLog('shouldAllowDeprecatedTLS');
        return shouldAllowDeprecatedTLS(controller, challenge);
      },
    );
  }
}
