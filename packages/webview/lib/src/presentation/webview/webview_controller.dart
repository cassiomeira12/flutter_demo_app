import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:webview/src/domain/domain.dart';
import 'package:webview/src/presentation/widgets/web_view/webview_widget_controller.dart';

class WebViewController extends LifecycleController {
  final String _globalKeyHash;
  final LocalStorageUseCase _localStorageUseCase;
  final CheckInternetConnectionUseCase _checkInternetUseCase;
  final OpenWebUrlUseCase _openWebUrlUseCase;
  final ShareUseCase _shareUseCase;
  final Future<void> Function(String url) _openPage;
  final List<ReloadExpiredUrlEntity> _reloadExpiredUrls;

  WebViewController({
    required String globalKeyHash,
    required LocalStorageUseCase localStorage,
    required CheckInternetConnectionUseCase checkInternetUseCase,
    required OpenWebUrlUseCase openWebUrlUseCase,
    required ShareUseCase shareUseCase,
    required Future<void> Function(String url) openPage,
    required List<ReloadExpiredUrlEntity> reloadExpiredUrls,
  }) : _globalKeyHash = globalKeyHash,
       _localStorageUseCase = localStorage,
       _checkInternetUseCase = checkInternetUseCase,
       _openWebUrlUseCase = openWebUrlUseCase,
       _shareUseCase = shareUseCase,
       _openPage = openPage,
       _reloadExpiredUrls = reloadExpiredUrls;

  late String url;

  int scrollX = 0;
  int scrollY = 0;

  WebViewWidgetController? _webViewController;

  final RxString errorMessage = RxString('');

  DateTime? _previousTimeReloadedWebView;
  DateTime? _lastTimeReloadedWebView;
  int _timesToRetryReload = 1;
  int secondsToStartWebViewReload = 10;

  LoadWebviewStepEnum? get currentStep => _webViewController?.currentStep;

  bool get canTryReloadAgain => _timesToRetryReload > 0;

  Stream<bool>? internetConnectionStream;

  Future<bool> get hasInternet => _checkInternetUseCase.call();

  final RxList<String> _logs = RxList.empty(growable: true);
  List<String> get logs {
    return _logs.reversed.map((log) {
      return log.replaceFirst(_globalKeyHash, '');
    }).toList();
  }

  bool _isPaused = false;
  void setPaused(bool paused) {
    _isPaused = paused;
  }

  final ValueNotifier<bool> _isLoading = ValueNotifier(true);
  ValueListenable<bool> get isLoadingValue => _isLoading;
  bool get isLoading => _isLoading.value;
  void setLoading(bool loading) {
    if (_isLoading.value != loading) {
      addLog('setLoading [$loading]');
      _isLoading.value = loading;
      if (loading) {
        setError(false);
        // _hasError.value = false;
      } else {
        if (!hasError && currentStep?.isErrorStep == false) {
          _previousTimeReloadedWebView = _lastTimeReloadedWebView;
          _lastTimeReloadedWebView = DateTime.now();
          addLog('WebView has loaded successfully now ✅');
        }
      }
    }
  }

  final ValueNotifier<bool> _hasError = ValueNotifier(false);
  ValueListenable<bool> get hasErrorValue => _hasError;
  bool get hasError => _hasError.value;
  void setError(bool error) {
    if (_hasError.value != error) {
      addLog('setError [$error]');
      _hasError.value = error;
      showWebView.value = !error;
      if (error) {
        _webViewController?.errorStep();
        _webViewController?.stopLoadingTimer();
        setWebViewController(null);
        setLoading(false);
        addLog('WebView has loaded with error now ❌');
      }
    }
  }

  bool? isNetworkError;

  final ValueNotifier<bool> _processGone = ValueNotifier(false);
  ValueListenable<bool> get processGoneValue => _processGone;
  bool get processGone => _processGone.value;
  void setProcessGone(bool processGone) {
    if (_processGone.value != processGone) {
      addLog('setProcessGone [$processGone]');
      _processGone.value = processGone;
      showWebView.value = !processGone;
      if (processGone) {
        setLoading(true);
        _webViewController?.stopLoadingTimer();
        setWebViewController(null);
        if (appInForeground) {
          _recreateWebView();
        }
      }
    }
  }

  final ValueNotifier<bool> showWebView = ValueNotifier(true);

  ValueNotifier<int> get lastProgress {
    return _webViewController?.lastProgress ?? ValueNotifier(0);
  }

  void setWebViewController(WebViewWidgetController? controller) {
    _webViewController = controller;
  }

  void addLog(String log) {
    final String time = DateHelper.formatHourMinuteSeconds(DateTime.now());
    final String loggedTimer = 'webview_widget [$time] $_globalKeyHash $log';
    CrashlyticsServiceManager.instance.log(loggedTimer);
    _logs.add(loggedTimer.replaceAll('webview_widget ', ''));
  }

  void updateScrollPosition(int x, int y) {
    scrollX = x;
    scrollY = y;
  }

  void scrollToTop() {
    _webViewController?.scrollTo(x: 0, y: 0, animated: true);
  }

  Future<void> saveScrollPosition() async {
    final scrollPosition = {'x': scrollX, 'y': scrollY};
    await _localStorageUseCase.set(url, scrollPosition);
  }

  Future<void> openExternalLink(Uri uri) async {
    addLog('openExternalLink $uri');
    if (uri.scheme.contains('appbase')) {
      return;
    }
    try {
      HapticFeedback.lightImpact();
      await _openWebUrlUseCase.call(url);
    } catch (_) {
      //
    }
  }

  Future<void> openLink(String link) async {
    saveScrollPosition();
    pauseWebView();
    _isPaused = true;
    HapticFeedback.lightImpact();
    await _openPage.call(link);
    _isPaused = false;
    resumeWebView();
  }

  void pauseWebView() {
    addLog('pauseWebView');
    setPaused(true);
    _webViewController?.pause();
  }

  void resumeWebView() {
    addLog('resumeWebView');
    setPaused(false);
    _webViewController?.resume();
    _reloadIfNeed();
  }

  Future<void> _reloadIfNeed() async {
    final hasInternetConnection = await hasInternet;
    if (hasInternetConnection) {
      _resetTimesToRetry();
      if (processGone || hasError) {
        _recreateWebView();
      } else {
        final bool webViewContentExpired = _isWebViewContentExpired();
        if (webViewContentExpired) {
          reloadWebView(initialUrl: webViewContentExpired);
        }
      }
    }
  }

  void _resetTimesToRetry() {
    _timesToRetryReload = 2;
    secondsToStartWebViewReload = 10;
  }

  void tryAgain() {
    addLog('tryAgain');
    _resetTimesToRetry();
    isNetworkError = null;
    if (processGone || hasError) {
      _recreateWebView();
    }
  }

  Future<void> reloadWebView({bool initialUrl = false}) async {
    addLog('reloadWebView initialUrl [$initialUrl]');
    if (!_isPaused) {
      if (processGone || hasError) {
        _resetTimesToRetry();
        await _recreateWebView();
      } else {
        await _webViewController?.reload(initialUrl: initialUrl);
      }
    }
  }

  Future<void> _recreateWebView() async {
    if (_isPaused) {
      // ocultar tela de erro pro usuário antes de recriar
      setLoading(true);
      return;
    }

    if (!canTryReloadAgain) {
      addLog('recreateWebView not executed');
      isNetworkError = true;
      errorMessage.value =
          'Não foi possível carregar a página, verifique sua conexão com a internet';
      setError(true);
      return;
    }

    addLog('recreateWebView timesToRetryReload: [$_timesToRetryReload]');

    setLoading(true);
    await Future.delayed(const Duration(milliseconds: 500));
    final scrollPosition = await _localStorageUseCase.get<Map<String, dynamic>>(
      url,
    );
    if (scrollPosition != null) {
      scrollX = scrollPosition['x'] ?? 0;
      scrollY = scrollPosition['y'] ?? 0;
    }
    //
    ++secondsToStartWebViewReload;
    --_timesToRetryReload;
    setProcessGone(false);
  }

  bool _isWebViewContentExpired() {
    if (!processGone && _lastTimeReloadedWebView != null && !_isPaused) {
      final now = DateTime.now();
      final Duration differenceTime = now.difference(_lastTimeReloadedWebView!);
      for (final regex in _reloadExpiredUrls) {
        if (regex.enable && regex.pattern.hasMatch(url)) {
          final String limiteTime = 'limit: [${regex.expiredTime}]';
          if (differenceTime.inSeconds > regex.expiredTime.inSeconds) {
            addLog(
              'reloadIfExpired webview expired [$differenceTime] $limiteTime',
            );
            return true;
          } else {
            addLog('webview not expired yet [$differenceTime] $limiteTime');
          }
        }
      }
    }
    return false;
  }

  void internetConnectionListener(bool hasInternet) {
    addLog('internetConnectionListener connected: [$hasInternet]');
    if (_isPaused) return;
    if (hasInternet) {
      final bool isSuccessStep =
          _webViewController?.currentStep.isSuccessStep ?? false;
      final bool isErrorStep =
          _webViewController?.currentStep.isErrorStep ?? true;
      if (isLoading || !isSuccessStep || isErrorStep) {
        tryAgain();
      }
    }
  }

  Future<bool> checkInternetConnection() => _checkInternetUseCase.call();

  void noInternetConnectionCallback() {
    addLog('noInternetConnectionCallback');
    _lastTimeReloadedWebView = _previousTimeReloadedWebView;
    DialogWidget.show(
      super.context,
      title: 'Internet',
      message: 'Você está sem conexão com a internet',
    );
    // Get.showSnackbar(
    //   const GetSnackBar(
    //     title: 'Internet',
    //     message: 'Você está sem conexão com a internet',
    //     backgroundColor: AppColors.statusWarning,
    //     maxWidth: ResponsiveSizeHelper.maxWidth,
    //     duration: Duration(seconds: 1),
    //     snackStyle: SnackStyle.GROUNDED,
    //   ),
    // );
  }

  Future<void> shareLogs() async {
    String logsToShare = logs.join('\n');
    logsToShare = 'Debug logs\n\n$logsToShare';
    final result = await _shareUseCase.call(
      title: 'Debug logs',
      text: logsToShare,
    );
    clickTagging(component: 'share_data $result');
  }

  @override
  void onAppResumed() {
    _reloadIfNeed();
  }

  @override
  void onAppBackground() {
    saveScrollPosition();
  }

  @override
  void onReady() {
    super.onReady();
    internetConnectionStream = _checkInternetUseCase.internetStream
        .asBroadcastStream();
    internetConnectionStream?.listen(internetConnectionListener);
  }

  @override
  void onClose() {
    addLog('onClose controller');
    _localStorageUseCase.delete(url);
    _checkInternetUseCase.dispose();
    errorMessage.close();
    _logs.close();
    super.onClose();
  }
}
