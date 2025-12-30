import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import '../../../data/data.dart';
import '../../../domain/domain.dart';

abstract class WebViewWidgetController {
  void setInAppWebViewController(InAppWebViewController? controller);

  Future<Uri?> get originalUri;

  Future<Uri?> get currentUri;

  Uri? setCurrentUri(Uri? uri);

  Future<String> get defaultUserAgent;

  Future<String> get currentUserAgent;

  Stream<bool> get showWebView;

  void showWebViewWidget();

  void hideWebViewWidget();

  bool get isPaused;

  void pause();

  void resume();

  Future<void> scrollTo({
    required int x,
    required int y,
    bool animated = false,
  });

  Future<void> reload({bool initialUrl = false});

  void addJavaScriptHandler({
    required String handlerName,
    required JavaScriptHandlerCallback callback,
  });

  Future<dynamic> evaluateJavascript({
    required String source,
    ContentWorld? contentWorld,
  });

  Timer? checkWebViewIsLoadingTicker;

  String get globalKeyHash;

  int get lastProgress;
  void setProgress(int value);

  void clearLoadingManager();

  LoadWebviewStepEnum get currentStep;

  Future<void> startLoadingTimer();
  Future<void> stopLoadingTimer();
  void nextStep();
  void errorStep();

  void dispose();
}

class WebViewWidgetControllerImpl implements WebViewWidgetController {
  final String _globalKeyHash;
  final void Function() processGone;
  final int _secondsToStartWebViewReload;
  final void Function(bool isLoading) loading;
  final void Function(String log) onLog;
  final void Function() noInternetConnectionCallback;

  WebViewWidgetControllerImpl({
    required String globalKeyHash,
    required String url,
    required this.processGone,
    required int secondsToStartWebViewReload,
    required this.loading,
    required this.onLog,
    required this.noInternetConnectionCallback,
  }) : _globalKeyHash = globalKeyHash,
       _secondsToStartWebViewReload = secondsToStartWebViewReload {
    _currentUri = Uri.parse(url);
  }

  final StreamController<bool> _showWebView = StreamController();
  @override
  Stream<bool> get showWebView => _showWebView.stream;

  @override
  void showWebViewWidget() {
    if (!_showWebView.isClosed) {
      _isPaused = false;
      _webviewWasRemovedFromWidgetTree = false;
      _showWebView.add(true);
    }
  }

  @override
  void hideWebViewWidget() {
    if (!_showWebView.isClosed && _isPaused) {
      _webviewWasRemovedFromWidgetTree = true;
    }
  }

  bool _webviewWasRemovedFromWidgetTree = false;

  InAppWebViewController? _inAppWebViewController;

  InAppWebViewController? get inAppWebViewController {
    return _webviewWasRemovedFromWidgetTree ? null : _inAppWebViewController;
  }

  @override
  void setInAppWebViewController(InAppWebViewController? controller) {
    _inAppWebViewController = controller;
  }

  bool _isPaused = false;
  @override
  bool get isPaused => _isPaused;

  @override
  String get globalKeyHash => _globalKeyHash;

  Uri? _currentUri;
  @override
  Uri? setCurrentUri(Uri? uri) => _currentUri = uri;

  Uri _replaceUri(Uri uri) {
    final bool endsWithSlash = uri.path.endsWith('/');
    final String path = endsWithSlash
        ? uri.path.substring(0, uri.path.length - 1)
        : uri.path;
    return Uri(
      scheme: uri.scheme,
      host: uri.host,
      path: path,
      query: uri.query,
    );
  }

  @override
  Future<Uri?> get currentUri async {
    if (_currentUri != null) return _currentUri;
    try {
      final webUri = await inAppWebViewController?.getUrl();
      final uri = webUri?.uriValue;
      if (uri == null) return null;
      return setCurrentUri(uri);
    } catch (error, stackTrace) {
      Log.error('currentUri', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  @override
  Future<Uri?> get originalUri async {
    try {
      final webUri = await inAppWebViewController?.getOriginalUrl();
      final uri = webUri?.uriValue;
      if (uri == null) return null;
      return _replaceUri(uri);
    } catch (error, stackTrace) {
      Log.error('originalUri', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  @override
  Future<String> get defaultUserAgent async {
    try {
      return await InAppWebViewController.getDefaultUserAgent();
    } catch (error, stackTrace) {
      Log.error('defaultUserAgent', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<String> get currentUserAgent async {
    try {
      final result = await evaluateJavascript(source: 'navigator.userAgent');
      assert(result is String, 'UserAgent must be String');
      return result;
    } catch (_) {
      return await defaultUserAgent;
    }
  }

  @override
  void pause() {
    onLog('pause');
    try {
      if (Platform.isAndroid) {
        inAppWebViewController?.pause();
      }
      if (Platform.appleDevice) {
        inAppWebViewController?.setAllMediaPlaybackSuspended(suspended: true);
      }
      _isPaused = true;
      _pauseLoadingTimer();
    } catch (error, stackTrace) {
      _isPaused = false;
      Log.error('pause', error: error, stackTrace: stackTrace);
    }
  }

  @override
  void resume() {
    if (_webviewWasRemovedFromWidgetTree) {
      showWebViewWidget();
      return;
    }

    onLog('resume');
    try {
      if (Platform.isAndroid) {
        inAppWebViewController?.resume();
      }
      if (Platform.appleDevice) {
        inAppWebViewController?.setAllMediaPlaybackSuspended(suspended: false);
      }
      _isPaused = false;
      _resumeLoadingTimer();
    } catch (error, stackTrace) {
      _isPaused = true;
      Log.error('resume', error: error, stackTrace: stackTrace);
    }
  }

  @override
  Future<void> scrollTo({
    required int x,
    required int y,
    bool animated = false,
  }) async {
    try {
      await inAppWebViewController?.scrollTo(x: x, y: y, animated: animated);
    } catch (error, stackTrace) {
      Log.error('scrollTo', error: error, stackTrace: stackTrace);
    }
  }

  @override
  Future<void> reload({bool initialUrl = false}) async {
    try {
      loading(true);
      // TODO alterar aqui
      final checker = AppBinding.find<CheckInternetConnectionUseCase>();
      final hasInternet = await checker.call();
      onLog('reload has internet connection [$hasInternet]');
      if (!hasInternet) {
        loading(false);
        noInternetConnectionCallback();
        return;
      }

      if (Platform.isAndroid) {
        if (initialUrl) {
          return processGone();
        }
        return inAppWebViewController?.reload();
      }

      clearLoadingManager();
      startLoadingTimer();

      final uri = initialUrl ? await originalUri : await currentUri;
      if (Platform.appleDevice) {
        return inAppWebViewController?.loadUrl(
          urlRequest: URLRequest(
            url: WebUri.uri(uri!),
            // cachePolicy: URLRequestCachePolicy.RELOAD_IGNORING_LOCAL_CACHE_DATA,
            cachePolicy: URLRequestCachePolicy.RELOAD_REVALIDATING_CACHE_DATA,
          ),
        );
      }
      return inAppWebViewController?.reload();
    } catch (error, stackTrace) {
      Log.error('reload', error: error, stackTrace: stackTrace);
    }
  }

  @override
  void addJavaScriptHandler({
    required String handlerName,
    required JavaScriptHandlerCallback callback,
  }) {
    try {
      inAppWebViewController?.addJavaScriptHandler(
        handlerName: handlerName,
        callback: callback,
      );
    } catch (error, stackTrace) {
      Log.error('addJavaScriptHandler', error: error, stackTrace: stackTrace);
    }
  }

  @override
  Future<dynamic> evaluateJavascript({
    required String source,
    ContentWorld? contentWorld,
  }) async {
    try {
      return await inAppWebViewController?.evaluateJavascript(
        source: source,
        contentWorld: contentWorld,
      );
    } catch (error, stackTrace) {
      Log.error('evaluateJavascript', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  LoadWebviewStepEnum _currentStep = LoadWebviewStepEnum.webViewCreated;

  Timer? _checkWebViewIsLoadingTicker;

  @override
  LoadWebviewStepEnum get currentStep => _currentStep;

  int _lastProgress = 0;
  @override
  int get lastProgress => _lastProgress;
  @override
  void setProgress(int value) {
    _lastProgress = value;
  }

  @override
  Timer? checkWebViewIsLoadingTicker;

  int tickerMilliseconds = 250;

  @override
  void clearLoadingManager() {
    setProgress(0);
    _currentStep = LoadWebviewStepEnum.loadStarted;
  }

  Future<void> _checkIfWebViewIsReady(Timer timer) async {
    try {
      final time = Duration(milliseconds: timer.tick * tickerMilliseconds);
      onLog('Timer ${time.inMilliseconds} milliseconds');
      if (time.inSeconds < _secondsToStartWebViewReload) {
        // call javascript after start progressChanged step
        if (_currentStep.isGreaterThanProgressStep) {
          final bool isReady = await evaluateJavascript(
            source: scriptLoadingFinished,
          );
          onLog('checkIfWebViewIsReady isReady [$isReady]');
          final bool hideSkeleton = isReady;
          if (hideSkeleton) {
            successStep();
            stopLoadingTimer();
            loading(false);
            timer.cancel();
          }
        }
      } else {
        onLog(
          'loading timeout ${_secondsToStartWebViewReload}s -> FORCE RELOAD',
        );
        errorStep();
        stopLoadingTimer();
        processGone();
        timer.cancel();
      }
    } catch (_) {}
  }

  @override
  Future<void> startLoadingTimer() async {
    //webViewController.currentStep.isGreaterThanProgressStep
    if (currentStep.isFinished) return;
    if (_checkWebViewIsLoadingTicker?.tick == 0) return;

    loading(true);
    if (_checkWebViewIsLoadingTicker == null) {
      onLog('LoadingTimer [start] ⏲');
    } else {
      onLog('LoadingTimer [restart] ⏲');
      _checkWebViewIsLoadingTicker?.cancel();
    }
    final period = Duration(milliseconds: tickerMilliseconds);
    _checkWebViewIsLoadingTicker = Timer.periodic(
      period,
      _checkIfWebViewIsReady,
    );
  }

  @override
  Future<void> stopLoadingTimer() async {
    if (_checkWebViewIsLoadingTicker?.isActive ?? false) {
      onLog('LoadingTimer [stop]');
      _checkWebViewIsLoadingTicker?.cancel();
      _checkWebViewIsLoadingTicker = null;
    }
  }

  bool _isTimerPaused = false;

  void _resumeLoadingTimer() {
    if (_isTimerPaused) {
      onLog('LoadingTimer [resume]');
      _checkWebViewIsLoadingTicker = null;
      _isTimerPaused = false;
      startLoadingTimer();
    }
  }

  void _pauseLoadingTimer() {
    if (_checkWebViewIsLoadingTicker?.isActive ?? false) {
      onLog('LoadingTimer [pause]');
      _checkWebViewIsLoadingTicker?.cancel();
      _isTimerPaused = true;
    }
  }

  @override
  void nextStep() {
    switch (currentStep) {
      case LoadWebviewStepEnum.webViewCreated:
        _currentStep = LoadWebviewStepEnum.loadStarted;
      case LoadWebviewStepEnum.loadStarted:
        _currentStep = LoadWebviewStepEnum.progressChanged;
      case LoadWebviewStepEnum.progressChanged:
        _currentStep = LoadWebviewStepEnum.pageVisible;
      case LoadWebviewStepEnum.pageVisible:
        _currentStep = LoadWebviewStepEnum.loadStopped;
      case LoadWebviewStepEnum.loadStopped:
        _currentStep = LoadWebviewStepEnum.successLoaded;
        loading(false);
      case LoadWebviewStepEnum.error:
      case LoadWebviewStepEnum.successLoaded:
    }
  }

  void successStep() {
    _currentStep = LoadWebviewStepEnum.successLoaded;
  }

  @override
  void errorStep() {
    _currentStep = LoadWebviewStepEnum.error;
  }

  @override
  void dispose() {
    _showWebView.close();
    stopLoadingTimer();
  }
}
