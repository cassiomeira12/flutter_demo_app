import 'dart:developer' as developer;

import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:webview/src/presentation/mixins/mixins.dart';
import 'package:webview/src/presentation/webview/widgets/webview_widget_controller.dart';

class WebViewHeadless extends BaseController
    with LoadCallbacksMixin, NavigatorCallbacksMixin, ErrorCallbacksMixin {
  late WebViewWidgetController _webViewController;
  late HeadlessInAppWebView _headlessWebView;

  final Uri _uri;

  WebViewHeadless({
    required Uri? uri,
  }) : _uri = uri ?? Uri.parse('about:blank') {
    _createWebViewHeadless();
  }

  final Completer _completer = Completer<void>();
  HeadlessInAppWebView get headlessWebView => _headlessWebView;

  @override
  void onClose() {
    _headlessWebView.dispose();
    super.onClose();
  }

  Future<void> run() async {
    _webViewController.startTrackPerformance(_uri);
    await _headlessWebView.run();
    return _completer.future;
  }

  Future<void> loadUrl(Uri uri) {
    return _webViewController.loadUrl(uri);
  }

  void onLog(String log) {
    final String time = DateHelper.formatHourMinuteSeconds(DateTime.now());
    final String loggedTimer = '[$time] $log';
    developer.log(loggedTimer, name: 'WebViewWidget Headless');
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
    if (Platform.isAndroid) {
      InAppWebViewController.setWebContentsDebuggingEnabled(false);
    }

    _webViewController = WebViewWidgetControllerImpl(
      globalKeyHash: GlobalKey().toString(),
      uri: _uri,
      processGone: processGone,
      secondsToStartWebViewReload: 15, // widget.secondsToStartWebViewReload,
      loading: loading,
      onLog: onLog,
      checkInternet: () => Future.value(true),
      noInternetConnectionCallback: () {},
      onFinishFullLoading: () {
        if (!_completer.isCompleted) _completer.complete();
      },
    );

    _headlessWebView = HeadlessInAppWebView(
      initialSettings: InAppWebViewSettings(
        isInspectable: !kReleaseMode,
        // userAgent: widget.userAgent,
        allowsLinkPreview: false,
        allowsBackForwardNavigationGestures: false,
        allowsInlineMediaPlayback: Platform.appleDevice,
        allowsPictureInPictureMediaPlayback: false,
        disableDefaultErrorPage: true,
        verticalScrollBarEnabled: false,
        horizontalScrollBarEnabled: false,
        sharedCookiesEnabled: Platform.appleDevice,
        supportZoom: false,
        supportMultipleWindows: true,
        mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
        useOnLoadResource: true,
        useOnNavigationResponse: true,
        useOnRenderProcessGone: true,
        useShouldOverrideUrlLoading: true,
        useShouldInterceptAjaxRequest: false,
        useShouldInterceptFetchRequest: false,
        underPageBackgroundColor: StaticColors.white,
        // cacheMode: CacheMode.LOAD_CACHE_ELSE_NETWORK,
      ),
      initialUrlRequest: URLRequest(url: WebUri.uri(_uri)),
      onCreateWindow: (_, createWindowAction) async {
        if (_webViewController.isPaused) {
          onLog('onCreateWindow CANCEL [isPaused]');
          return Future.value(true);
        }
        await shouldOverrideUrlLoading(
          createWindowAction,
          webViewController: _webViewController,
          click: (_) {},
          onLog: onLog,
          openExternalLink: (_) {},
        );
        return Future.value(true);
      },
      onWebViewCreated: (controller) {
        _webViewController.setInAppWebViewController(controller);
        // widget.onCreateController(_webViewController);
        return onWebViewCreated(
          _uri.toString(),
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
        // return onProgressChanged(
        //   progress,
        //   webViewController: _webViewController,
        //   onLog: onLog,
        // );
      },
      onPageCommitVisible: (_, url) {
        return onPageCommitVisible(
          url,
          webViewController: _webViewController,
          onLog: onLog,
          processGone: processGone,
        );

        // _webViewController.stopLoadingTimer();
        // _webViewController.finishTrackPerformance();
        // _webViewController.finishFullLoadingTracking();
      },
      onLoadStop: (_, url) {
        return onLoadStop(
          url,
          webViewController: _webViewController,
          onLog: onLog,
          processGone: processGone,
        );

        // _webViewController.stopLoadingTimer();
        // _webViewController.finishTrackPerformance();
        // _webViewController.finishFullLoadingTracking();

        // if (!_completer.isCompleted) _completer.complete();
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
      // onScrollChanged: (_, int x, int y) {
      //   return onScrollChanged(
      //     x: _initialScrollX,
      //     y: _initialScrollY,
      //     onSaveScroll: onSaveScroll,
      //   );
      // },
      shouldOverrideUrlLoading: (controller, navigationAction) {
        if (_webViewController.isPaused) {
          onLog('shouldOverrideUrlLoading CANCEL [isPaused]');
          return Future.value(NavigationActionPolicy.CANCEL);
        }
        return shouldOverrideUrlLoading(
          navigationAction,
          webViewController: _webViewController,
          click: (_) {},
          onLog: onLog,
          openExternalLink: (_) {},
          // customCallbacks: null,
        );
      },
      onNavigationResponse: (_, _) {
        return Future.value(NavigationResponseAction.ALLOW);
      },
      onReceivedServerTrustAuthRequest: (_, _) {
        return Future.value(
          ServerTrustAuthResponse(
            action: ServerTrustAuthResponseAction.PROCEED,
          ),
        );
      },
      onRenderProcessResponsive: (_, _) {
        onLog('onRenderProcessResponsive');
        return Future.value();
      },
      onRenderProcessUnresponsive: (_, _) {
        onLog('onRenderProcessUnresponsive');
        return Future.value();
      },
      shouldAllowDeprecatedTLS: (_, _) {
        onLog('shouldAllowDeprecatedTLS');
        return Future.value(ShouldAllowDeprecatedTLSAction.ALLOW);
      },
    );
  }
}
