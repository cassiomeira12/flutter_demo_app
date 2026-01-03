import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import '../../../data/data.dart';
import 'webview_widget_controller.dart';

class WebViewWidget extends StatefulWidget {
  final String globalKeyHash;
  final String initialUrl;
  final String Function(String url)? replaceUrl;
  final String? userAgent;
  final int? initialScrollX;
  final int? initialScrollY;
  final int secondsToStartWebViewReload;
  final void Function(WebViewWidgetController?) onCreateController;
  final void Function(bool isLoading) loading;
  final void Function({required bool isNetworkError, String? error}) onError;
  final void Function(String url) click;
  final void Function(int x, int y) onSaveScroll;
  final void Function() processGone;
  final void Function(String log) onLog;
  final void Function(Uri uri) openExternalLink;
  final void Function() noInternetConnectionCallback;

  final Widget? onLoadingWidget;
  final Widget Function(String error)? onErrorWidget;

  const WebViewWidget({
    super.key,
    required this.globalKeyHash,
    required this.initialUrl,
    this.replaceUrl,
    this.userAgent,
    this.initialScrollX,
    this.initialScrollY,
    required this.secondsToStartWebViewReload,
    required this.onCreateController,
    required this.loading,
    required this.onError,
    required this.click,
    required this.onSaveScroll,
    required this.processGone,
    this.onLoadingWidget,
    this.onErrorWidget,
    required this.onLog,
    required this.openExternalLink,
    required this.noInternetConnectionCallback,
  });

  @override
  State<WebViewWidget> createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidget>
    with
        AutomaticKeepAliveClientMixin,
        LoadCallbacksExtension,
        NavigatorCallbacksExtension,
        ErrorCallbacksExtension {
  late int _initialScrollX;
  late int _initialScrollY;

  String get globalKeyHash => widget.globalKeyHash;

  late WebViewWidgetController _webViewController;
  PullToRefreshController? _pullToRefreshController;

  PullToRefreshController? pullToRefreshController(BuildContext context) {
    if (Platform.isMobile) {
      _pullToRefreshController = PullToRefreshController(
        settings: PullToRefreshSettings(
          color: Theme.of(context).primaryColor,
          backgroundColor: Colors.white,
        ),
        onRefresh: () async {
          widget.onLog('PullToRefresh reload');
          await Future.delayed(const Duration(seconds: 1));
          await _webViewController.reload();
          _pullToRefreshController?.endRefreshing();
        },
      );
    }
    return _pullToRefreshController;
  }

  URLRequest get _initialRequest {
    late String url;
    if (widget.replaceUrl == null) {
      url = widget.initialUrl;
    } else {
      url = widget.replaceUrl!(widget.initialUrl);
    }
    return URLRequest(url: WebUri(url));
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      InAppWebViewController.setWebContentsDebuggingEnabled(false);
    }
    PlatformInAppWebViewController.debugLoggingSettings = DebugLoggingSettings(
      enabled: false,
      usePrint: true,
      excludeFilter: [
        RegExp('onCreateWindow'),
        RegExp('onWebViewCreated'),
        RegExp('onLoadStart'),
        RegExp('onProgressChanged'),
        RegExp('onPageCommitVisible'),
        RegExp('onLoadStop'),
        RegExp('onConsoleMessage'),
        RegExp('onUpdateVisitedHistory'),
        RegExp('shouldInterceptFetchRequest'),
        RegExp('shouldOverrideUrlLoading'),
        RegExp('onReceivedServerTrustAuthRequest'),
        RegExp('shouldOverrideUrlLoading'),
        RegExp('onNavigationResponse'),
        RegExp('onLoadResource'),
        RegExp('onTitleChanged'),
        RegExp('onScrollChanged'),
        RegExp('onWindowFocus'),
        RegExp('onWindowBlur'),
        RegExp('onContentSizeChanged'),
        RegExp('onOverScrolled'),
        //
        RegExp('onReceivedHttpError'),
      ],
    );
    _initialScrollX = widget.initialScrollX ?? 0;
    _initialScrollY = widget.initialScrollY ?? 0;
    _webViewController = WebViewWidgetControllerImpl(
      globalKeyHash: globalKeyHash,
      url: widget.initialUrl,
      processGone: widget.processGone,
      secondsToStartWebViewReload: widget.secondsToStartWebViewReload,
      loading: widget.loading,
      onLog: widget.onLog,
      noInternetConnectionCallback: widget.noInternetConnectionCallback,
    );
    Future.delayed(
      const Duration(milliseconds: 500),
      _webViewController.showWebViewWidget,
    );
    print('webview_widget $globalKeyHash -----------------------------------');
    widget.onLog('initState');
  }

  @override
  void dispose() {
    _webViewController.dispose();
    widget.onLog('dispose');
    print('webview_widget $globalKeyHash -----------------------------------');
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
      stream: _webViewController.showWebView,
      builder: (context, snapshot) {
        if (snapshot.data == true && !_webViewController.isPaused) {
          return InAppWebView(
            key: GlobalKey(debugLabel: globalKeyHash),
            initialSettings: InAppWebViewSettings(
              isInspectable: kDebugMode,
              userAgent: widget.userAgent,
              // javaScriptEnabled: true,
              allowsLinkPreview: false,
              // allowBackgroundAudioPlaying: false,
              allowsBackForwardNavigationGestures: false,
              allowsInlineMediaPlayback: Platform.appleDevice,
              disableDefaultErrorPage: true,
              // disableHorizontalScroll: false,
              verticalScrollBarEnabled: false,
              horizontalScrollBarEnabled: false,
              mediaPlaybackRequiresUserGesture: false,
              sharedCookiesEnabled: Platform.appleDevice,
              //
              supportZoom: false,
              // minimumZoomScale: 1.0,
              // maximumZoomScale: 1.0,
              //
              supportMultipleWindows: true,
              // useHybridComposition: true,
              useOnLoadResource: true,
              useOnNavigationResponse: true,
              useOnRenderProcessGone: true,
              useShouldOverrideUrlLoading: true,
              //
              transparentBackground: true,
              underPageBackgroundColor: StaticColors.white,
            ),
            initialUrlRequest: _initialRequest,
            pullToRefreshController: pullToRefreshController(context),
            onWebViewCreated: (controller) {
              _webViewController.setInAppWebViewController(controller);
              widget.onCreateController(_webViewController);
              return onWebViewCreated(
                widget.initialUrl,
                webViewController: _webViewController,
                loading: widget.loading,
                onLog: widget.onLog,
              );
            },
            onLoadStart: (_, url) {
              return onLoadStart(
                url,
                webViewController: _webViewController,
                onLog: widget.onLog,
              );
            },
            onProgressChanged: (_, progress) {
              return onProgressChanged(
                progress,
                webViewController: _webViewController,
                onLog: widget.onLog,
              );
            },
            onPageCommitVisible: (_, url) {
              return onPageCommitVisible(
                url,
                webViewController: _webViewController,
                onLog: widget.onLog,
                processGone: widget.processGone,
              );
            },
            onLoadStop: (_, url) {
              return onLoadStop(
                url,
                webViewController: _webViewController,
                onLog: widget.onLog,
                processGone: widget.processGone,
              );
            },
            onReceivedError: (_, request, error) {
              return onReceivedError(
                request,
                error,
                onError: widget.onError,
                onLog: widget.onLog,
              );
            },
            onReceivedHttpError: (_, request, errorResponse) {
              return onReceivedHttpError(
                request,
                errorResponse,
                onError: widget.onError,
                onLog: widget.onLog,
                processGone: widget.processGone,
              );
            },
            onRenderProcessGone: (_, detail) {
              _webViewController.setInAppWebViewController(null);
              return onRenderProcessGone(
                detail,
                onLog: widget.onLog,
                processGone: widget.processGone,
              );
            },
            onWebContentProcessDidTerminate: (_) {
              _webViewController.setInAppWebViewController(null);
              return onWebContentProcessDidTerminate(
                onLog: widget.onLog,
                processGone: widget.processGone,
              );
            },
            onConsoleMessage: (_, consoleMessage) {},
            onScrollChanged: (controller, x, y) {
              _initialScrollX = x;
              _initialScrollY = y;
              return onScrollChanged(
                x: _initialScrollX,
                y: _initialScrollY,
                onSaveScroll: widget.onSaveScroll,
              );
            },
            shouldOverrideUrlLoading: (controller, navigationAction) {
              if (_webViewController.isPaused) {
                widget.onLog('shouldOverrideUrlLoading CANCEL [isPaused]');
                return Future.value(NavigationActionPolicy.CANCEL);
              }
              return shouldOverrideUrlLoading(
                controller,
                navigationAction,
                webViewController: _webViewController,
                click: widget.click,
                onLog: widget.onLog,
                openExternalLink: widget.openExternalLink,
              );
            },
            onNavigationResponse: (_, _) {
              return Future.value(NavigationResponseAction.ALLOW);
            },
            onReceivedServerTrustAuthRequest: (controller, challenge) {
              return onReceivedServerTrustAuthRequest(controller, challenge);
            },
            onRenderProcessResponsive: (_, _) {
              widget.onLog('onRenderProcessResponsive');
              return Future.value();
            },
            onRenderProcessUnresponsive: (_, _) {
              widget.onLog('onRenderProcessUnresponsive');
              return Future.value();
            },
            shouldAllowDeprecatedTLS: (controller, challenge) {
              widget.onLog('shouldAllowDeprecatedTLS');
              return shouldAllowDeprecatedTLS(controller, challenge);
            },
          );
        }
        _webViewController.hideWebViewWidget();
        return const SizedBox.shrink();
      },
    );
  }
}
