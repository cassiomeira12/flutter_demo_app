import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:webview/src/data/data.dart';
import 'package:webview/src/domain/enums/load_webview_step_enum.dart';

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

  TrackOperation? get trackPerformance;
  void startTrackPerformance(Uri? uri);
  void finishTrackPerformance({
    String? error,
    TrackOperationStatus status = TrackOperationStatus.ok,
  });
  TrackOperation? startOnCreatedWebViewTrack();
  void startOnStartLoadingTrack();

  Future<void> scrollTo({
    required int x,
    required int y,
    bool animated = false,
  });

  Future<void> loadUrl(Uri uri);

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

  ValueNotifier<int> get lastProgress;
  void setProgress(int value);

  void clearLoadingManager();

  LoadWebviewStepEnum get currentStep;

  Future<void> startLoadingTimer();
  Future<void> stopLoadingTimer();
  void nextStep();
  void errorStep();

  void finishFullLoadingTracking();

  void dispose();
}

class WebViewWidgetControllerImpl implements WebViewWidgetController {
  final String _globalKeyHash;
  final void Function() processGone;
  final int _secondsToStartWebViewReload;
  final void Function(bool isLoading) loading;
  final void Function(String log) onLog;
  final Future<bool> Function() _checkInternet;
  final void Function() noInternetConnectionCallback;

  WebViewWidgetControllerImpl({
    required String globalKeyHash,
    required Uri? uri,
    required this.processGone,
    required int secondsToStartWebViewReload,
    required this.loading,
    required this.onLog,
    required Future<bool> Function() checkInternet,
    required this.noInternetConnectionCallback,
  }) : _globalKeyHash = globalKeyHash,
       _checkInternet = checkInternet,
       _secondsToStartWebViewReload = secondsToStartWebViewReload {
    _currentUri = uri;
  }

  final StreamController<bool> _showWebView = StreamController();

  DateTime? _fullLoadingTrack;
  TrackOperation? _trackPerformance;
  TrackOperation? _onCreatedWebViewTrack;
  TrackOperation? _onStartedLoadingTrack;

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
      Log.error(error, stackTrace);
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
      Log.error(error, stackTrace);
      return null;
    }
  }

  @override
  Future<String> get defaultUserAgent async {
    try {
      return await InAppWebViewController.getDefaultUserAgent();
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
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
      Log.error(error, stackTrace);
    }
  }

  @override
  void resume() {
    if (_webviewWasRemovedFromWidgetTree) {
      return showWebViewWidget();
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
      Log.error(error, stackTrace);
    }
  }

  @override
  TrackOperation? get trackPerformance => _trackPerformance;

  @override
  void startTrackPerformance(Uri? uri) {
    final Uri? currentUri = uri ?? _currentUri;
    if (currentUri == null) return;
    late String url;
    try {
      url = '${currentUri.origin}${currentUri.path}';
    } catch (_) {
      url = currentUri.toString();
    }
    if (_trackPerformance == null) {
      _fullLoadingTrack = DateTime.timestamp();
      _trackPerformance = CrashlyticsServiceManager.instance.trackOperation(
        name: 'webview-performance-tracking',
        description: url,
      );
    }
    _trackPerformance?.setData(key: 'url', value: currentUri.toString());
  }

  @override
  void finishTrackPerformance({
    String? error,
    TrackOperationStatus status = TrackOperationStatus.ok,
  }) {
    if (error != null) {
      _trackPerformance?.setStatus(status);
      _trackPerformance?.setData(key: 'error', value: error);
    }

    _onCreatedWebViewTrack?.finish();
    _onStartedLoadingTrack?.finish();
    _trackPerformance?.finish();

    _onCreatedWebViewTrack = null;
    _onStartedLoadingTrack = null;
    _trackPerformance = null;
  }

  @override
  TrackOperation? startOnCreatedWebViewTrack() {
    return _onCreatedWebViewTrack = _trackPerformance?.startChild(
      name: 'webview-on-created-track',
    );
  }

  @override
  void startOnStartLoadingTrack() {
    _onStartedLoadingTrack = _trackPerformance?.startChild(
      name: 'webview-on-start-track',
    );
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
      Log.error(error, stackTrace);
    }
  }

  @override
  Future<void> loadUrl(Uri uri) async {
    await inAppWebViewController?.loadUrl(
      urlRequest: URLRequest(
        url: WebUri.uri(uri),
      ),
    );
  }

  @override
  Future<void> reload({bool initialUrl = false}) async {
    try {
      loading(true);

      final hasInternet = await _checkInternet.call();
      onLog('reload has internet connection [$hasInternet]');
      if (!hasInternet) {
        loading(false);
        noInternetConnectionCallback();
        return;
      }

      final uri = initialUrl ? await originalUri : await currentUri;

      if (Platform.isAndroid) {
        if (initialUrl) {
          finishTrackPerformance(
            error: 'reload',
            status: TrackOperationStatus.cancelled,
          );
          return processGone();
        }

        return loadUrl(uri!);
      }

      clearLoadingManager();
      startLoadingTimer();

      if (Platform.appleDevice) {
        return loadUrl(uri!);
      }

      return inAppWebViewController?.reload();
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
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
      Log.error(error, stackTrace);
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
      throw BaseException(
        message: 'evaluateJavascript',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  LoadWebviewStepEnum _currentStep = LoadWebviewStepEnum.webViewCreated;

  Timer? _checkWebViewIsLoadingTicker;

  @override
  LoadWebviewStepEnum get currentStep => _currentStep;

  final ValueNotifier<int> _lastProgress = ValueNotifier(0);
  @override
  ValueNotifier<int> get lastProgress => _lastProgress;
  @override
  void setProgress(int value) => _lastProgress.value = value;

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
      final seconds = time.inMilliseconds / 1000;

      onLog('Timer ${seconds.toStringAsFixed(3)} seconds');
      if (time.inSeconds < _secondsToStartWebViewReload) {
        // call javascript after start progressChanged step
        if (_currentStep.isGreaterThanProgressStep) {
          try {
            final bool isReady = await evaluateJavascript(
              source: scriptLoadingFinished,
            );
            if (_checkWebViewIsLoadingTicker == null) return;
            final bool hideSkeleton = isReady;
            if (hideSkeleton) {
              onLog(
                'checkIfWebViewIsReady isReady ${lastProgress.value}% ⏳',
              );
              successStep();
              stopLoadingTimer();
              loading(false);
              timer.cancel();
              finishTrackPerformance();
            }
          } on BaseException catch (error) {
            Log.baseException(error);
          }
        }
      } else {
        onLog(
          'checkIfWebViewIsReady FORCE RELOAD ${_secondsToStartWebViewReload}s',
        );
        stopLoadingTimer();
        timer.cancel();
        errorStep();
        finishTrackPerformance(
          error: 'loading timeout',
          status: TrackOperationStatus.dataLoss,
        );
        processGone();
      }
    } catch (_) {}
  }

  @override
  Future<void> startLoadingTimer() async {
    if (currentStep.isFinished) return;
    if (_checkWebViewIsLoadingTicker?.tick == 0) return;

    loading(true);
    onLog(
      'LoadingTimer [${_checkWebViewIsLoadingTicker == null ? 'start' : 'restart'}] ⏲',
    );
    if (_checkWebViewIsLoadingTicker != null) {
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
    _fullLoadingTrack = null;
  }

  @override
  void finishFullLoadingTracking() {
    if (_fullLoadingTrack != null) {
      final endTracking = DateTime.timestamp();
      final seconds =
          endTracking.difference(_fullLoadingTrack!).inMilliseconds / 1000;
      onLog('Full loading track: ${seconds.toStringAsFixed(3)} seconds');
    }
  }

  @override
  void dispose() {
    _showWebView.close();
    stopLoadingTimer();
    finishTrackPerformance(
      error: 'backPage',
      status: TrackOperationStatus.cancelled,
    );
  }
}
