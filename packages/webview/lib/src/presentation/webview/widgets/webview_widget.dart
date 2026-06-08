import 'dart:developer' as developer;

import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:webview/src/domain/domain.dart';
import 'package:webview/src/presentation/mixins/mixins.dart';
import 'package:webview/src/presentation/webview/widgets/webview_widget_controller.dart';

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
  final Future<bool> Function() checkInternet;
  final void Function() noInternetConnectionCallback;
  final CustomNavigatorCallback? customNavigatorCallback;

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
    required this.checkInternet,
    required this.noInternetConnectionCallback,
    this.customNavigatorCallback,
  });

  @override
  State<WebViewWidget> createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidget>
    with
        AutomaticKeepAliveClientMixin,
        LoadCallbacksMixin,
        NavigatorCallbacksMixin,
        ErrorCallbacksMixin {
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
          if (!context.mounted) return;
          widget.onLog('PullToRefresh reload');
          await Future.delayed(const Duration(milliseconds: 500));
          await _webViewController.reload();
          _pullToRefreshController?.endRefreshing();
        },
      );
    }
    return _pullToRefreshController;
  }

  late Uri _initialUri;

  @override
  void initState() {
    super.initState();
    _initialUri = Uri.parse(
      widget.replaceUrl?.call(widget.initialUrl) ?? widget.initialUrl,
    );
    if (Platform.isAndroid) {
      InAppWebViewController.setWebContentsDebuggingEnabled(false);
    }
    PlatformInAppWebViewController.debugLoggingSettings.enabled = false;
    _initialScrollX = widget.initialScrollX ?? 0;
    _initialScrollY = widget.initialScrollY ?? 0;
    _webViewController = WebViewWidgetControllerImpl(
      globalKeyHash: globalKeyHash,
      uri: _initialUri,
      processGone: widget.processGone,
      secondsToStartWebViewReload: widget.secondsToStartWebViewReload,
      loading: widget.loading,
      onLog: widget.onLog,
      checkInternet: widget.checkInternet,
      noInternetConnectionCallback: widget.noInternetConnectionCallback,
    );
    _webViewController.startTrackPerformance(_initialUri);
    final showWebViewTrack = _webViewController.trackPerformance?.startChild(
      name: 'webview-show-widget-track',
    );
    Future.delayed(AppRouterPage.pageTransition, () {
      _webViewController.showWebViewWidget();
      showWebViewTrack?.finish();
    });
    widget.onLog('initState $globalKeyHash -------------------------------');
  }

  @override
  void dispose() {
    _webViewController.dispose();
    widget.onLog('dispose $globalKeyHash -------------------------------');
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    developer.log('WebView Widget ${widget.globalKeyHash}', name: 'Rebuild');
    return StreamBuilder(
      stream: _webViewController.showWebView,
      builder: (context, snapshot) {
        if (snapshot.data == true && !_webViewController.isPaused) {
          return InAppWebView(
            key: GlobalKey(debugLabel: globalKeyHash),
            initialSettings: InAppWebViewSettings(
              isInspectable: !kReleaseMode,
              userAgent: widget.userAgent,
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
            ),
            initialUrlRequest: URLRequest(url: WebUri(_initialUri.toString())),
            pullToRefreshController: pullToRefreshController(context),
            onCreateWindow: (_, createWindowAction) async {
              if (!context.mounted) return Future.value(true);
              if (_webViewController.isPaused) {
                widget.onLog('onCreateWindow CANCEL [isPaused]');
                return Future.value(true);
              }
              await shouldOverrideUrlLoading(
                createWindowAction,
                webViewController: _webViewController,
                click: widget.click,
                onLog: widget.onLog,
                openExternalLink: widget.openExternalLink,
              );
              return Future.value(true);
            },
            onWebViewCreated: (controller) {
              if (!context.mounted) return;
              _webViewController.setInAppWebViewController(controller);
              widget.onCreateController(_webViewController);
              return onWebViewCreated(
                _initialUri.toString(),
                webViewController: _webViewController,
                loading: widget.loading,
                onLog: widget.onLog,
              );
            },
            onLoadStart: (_, url) {
              if (!context.mounted) return;
              if (Platform.isAndroid) {
                _webViewController.updateSystemThemeData(
                  Theme.brightnessOf(context).name,
                );
              }
              return onLoadStart(
                url,
                webViewController: _webViewController,
                onLog: widget.onLog,
              );
            },
            shouldOverrideUrlLoading: (controller, navigationAction) {
              if (!context.mounted) {
                return Future.value(NavigationActionPolicy.CANCEL);
              }
              return shouldOverrideUrlLoading(
                navigationAction,
                webViewController: _webViewController,
                click: widget.click,
                onLog: widget.onLog,
                openExternalLink: widget.openExternalLink,
                customCallbacks: widget.customNavigatorCallback,
              );
            },
            onProgressChanged: (_, progress) {
              if (!context.mounted) return;
              return onProgressChanged(
                progress,
                webViewController: _webViewController,
                onLog: widget.onLog,
              );
            },
            onPageCommitVisible: (_, url) {
              if (!context.mounted) return;
              if (Platform.appleDevice) {
                _webViewController.updateSystemThemeData(
                  Theme.brightnessOf(context).name,
                );
              }
              return onPageCommitVisible(
                url,
                webViewController: _webViewController,
                onLog: widget.onLog,
                processGone: widget.processGone,
              );
            },
            onLoadStop: (_, url) {
              if (!context.mounted) return;
              return onLoadStop(
                url,
                webViewController: _webViewController,
                onLog: widget.onLog,
                processGone: widget.processGone,
              );
            },
            onReceivedError: (_, request, error) {
              if (!context.mounted) return;
              return onReceivedError(
                request,
                error,
                webViewController: _webViewController,
                onError: widget.onError,
                onLog: widget.onLog,
              );
            },
            onReceivedHttpError: (_, request, errorResponse) {
              if (!context.mounted) return;
              return onReceivedHttpError(
                request,
                errorResponse,
                webViewController: _webViewController,
                onError: widget.onError,
                onLog: widget.onLog,
                processGone: widget.processGone,
              );
            },
            onRenderProcessGone: (_, detail) {
              if (!context.mounted) return;
              _webViewController.setInAppWebViewController(null);
              return onRenderProcessGone(
                detail,
                webViewController: _webViewController,
                onLog: widget.onLog,
                processGone: widget.processGone,
              );
            },
            onWebContentProcessDidTerminate: (_) {
              if (!context.mounted) return;
              _webViewController.setInAppWebViewController(null);
              return onWebContentProcessDidTerminate(
                webViewController: _webViewController,
                onLog: widget.onLog,
                processGone: widget.processGone,
              );
            },
            onScrollChanged: (_, int x, int y) {
              if (!context.mounted) return;
              _initialScrollX = x;
              _initialScrollY = y;
              return onScrollChanged(
                x: _initialScrollX,
                y: _initialScrollY,
                onSaveScroll: widget.onSaveScroll,
              );
            },
            onNavigationResponse: (_, _) {
              if (!context.mounted) {
                return Future.value(NavigationResponseAction.CANCEL);
              }
              widget.onLog('onNavigationResponse ALLOW');
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
              widget.onLog('onRenderProcessResponsive');
              return Future.value();
            },
            onRenderProcessUnresponsive: (_, _) {
              widget.onLog('onRenderProcessUnresponsive');
              return Future.value();
            },
            shouldAllowDeprecatedTLS: (_, _) {
              widget.onLog('shouldAllowDeprecatedTLS');
              return Future.value(ShouldAllowDeprecatedTLSAction.ALLOW);
            },
          );
        }
        _webViewController.hideWebViewWidget();
        return const SizedBox.shrink();
      },
    );
  }
}
