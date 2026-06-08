import 'dart:developer' as developer;

import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:webview/src/domain/domain.dart';
import 'package:webview/src/presentation/webview/widgets/webview_widget_controller.dart';

class WebViewController extends LifecycleController {
  final String _globalKeyHash;
  final LocalStorageUseCase _localStorage;
  final CheckInternetConnectionUseCase _checkInternetUseCase;
  final OpenWebUrlUseCase _openWebUrlUseCase;
  final ShareUseCase _shareUseCase;
  final Future<void> Function(String url) _openPage;
  final List<ReloadExpiredUrlEntity> _reloadExpiredUrls;

  WebViewController({
    required this._globalKeyHash,
    required this._localStorage,
    required this._checkInternetUseCase,
    required this._openWebUrlUseCase,
    required this._shareUseCase,
    required this._openPage,
    required this._reloadExpiredUrls,
  });

  late String initialUrl;

  int scrollX = 0;
  int scrollY = 0;

  WebViewWidgetController? _webViewController;

  String errorMessage = '';

  DateTime? _previousTimeReloadedWebView;
  DateTime? _lastTimeReloadedWebView;
  int _timesToRetryReload = 1;
  int secondsToStartWebViewReload = 10;

  LoadWebviewStepEnum? get currentStep => _webViewController?.currentStep;

  bool get canTryReloadAgain => _timesToRetryReload > 0;

  StreamSubscription<bool>? _internetConnectionSubscription;

  Future<bool> get hasInternet => _checkInternetUseCase.call();

  final RxList<String> _logs = RxList.empty(growable: true);
  List<String> get logs {
    return _logs.reversed.map((log) {
      return log.replaceFirst(_globalKeyHash, '');
    }).toList();
  }

  bool _isPaused = false;
  bool get isPaused => _isPaused;
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
  final ValueNotifier<int> lastProgress = ValueNotifier(0);

  void _lastProgressListener() {
    if (_webViewController != null) {
      lastProgress.value = _webViewController!.lastProgress.value;
    }
  }

  void setWebViewController(WebViewWidgetController? controller) {
    _webViewController?.lastProgress.removeListener(_lastProgressListener);
    _webViewController = controller;
    _webViewController?.lastProgress.addListener(_lastProgressListener);
  }

  void addLog(String log) {
    final String time = DateHelper.formatHourMinuteSeconds(DateTime.now());
    final String loggedTimer = '[$time] $_globalKeyHash $log';
    developer.log(loggedTimer, name: 'WebViewWidget');
    CrashlyticsServiceManager.instance.log(loggedTimer);
    _logs.add(loggedTimer.replaceAll('WebViewWidget ', ''));
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
    await _localStorage.set(initialUrl, scrollPosition);
  }

  Future<void> openExternalLink(Uri uri) async {
    addLog('openExternalLink $uri');
    if (uri.scheme.contains('appbase')) {
      return;
    }
    try {
      HapticFeedback.lightImpact();
      await _openWebUrlUseCase.call(uri.toString());
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
    }
  }

  Future<void> openLink(String link) async {
    saveScrollPosition();
    pauseWebView();
    HapticFeedback.lightImpact();
    await _openPage.call(link);
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
    final hasInternetConnection =
        _webViewController?.isInternetConnected ?? await hasInternet;
    if (hasInternetConnection) {
      _resetTimesToRetry();
      if (processGone || hasError) {
        _recreateWebView();
      } else {
        final bool webViewContentExpired = _isWebViewContentExpired();
        if (webViewContentExpired) {
          reloadWebView(initialUrl: true);
        }
      }
    }
  }

  Future<void> _checkInternetConnected() async {
    final hasInternetConnection =
        _webViewController?.isInternetConnected ?? await hasInternet;
    if (!hasInternetConnection) {
      showDialogNoInternetConnected();
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
      errorMessage =
          'Não foi possível carregar a página, verifique sua conexão com a internet';
      setError(true);
      return;
    }

    addLog('recreateWebView timesToRetryReload: [$_timesToRetryReload]');

    setLoading(true);
    await Future.delayed(const Duration(milliseconds: 500));
    final scrollPosition = await _localStorage.get<Map<String, dynamic>>(
      initialUrl,
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
        if (regex.enable && regex.pattern.hasMatch(initialUrl)) {
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

  void onInternetConnectionChanged(bool isConnected) {
    addLog('internetConnectionListener connected: [$isConnected]');
    _webViewController?.updateInternetConnection(isConnected);
    if (_isPaused || super.appInBackground) return;
    if (isConnected) {
      if (isLoading) {
        tryAgain();
      } else {
        _reloadIfNeed();
      }
    } else {
      showDialogNoInternetConnected();
    }
  }

  Future<bool> checkInternetConnection() => _checkInternetUseCase.call();

  void showDialogNoInternetConnected() {
    if (super.appInBackground || _isPaused) return;
    addLog('noInternetConnectionCallback');
    _lastTimeReloadedWebView = _previousTimeReloadedWebView;
    // DialogWidget.show(
    //   super.context,
    //   title: 'Internet',
    //   message: 'error_webview_no_network_message'.tr,
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

  void clearLogs() {
    _logs.clear();
  }

  @override
  void onAppForeground() {
    addLog('onAppForeground');
    _webViewController?.updateAppInBackground(false);
    if (!_isPaused) {
      _reloadIfNeed();
      _checkInternetConnected();
    }
  }

  @override
  void onAppBackground() {
    addLog('onAppBackground');
    _webViewController?.updateAppInBackground(true);
    if (!_isPaused) {
      _webViewController?.stopLoadingTimer();
    }
    saveScrollPosition();
  }

  @override
  void onReady() {
    super.onReady();
    _internetConnectionSubscription = _checkInternetUseCase.internetStream
        .listen(onInternetConnectionChanged);
  }

  @override
  void onClose() {
    addLog('onClose controller');
    _isLoading.dispose();
    _hasError.dispose();
    _processGone.dispose();
    showWebView.dispose();
    lastProgress.dispose();
    _webViewController?.lastProgress.removeListener(_lastProgressListener);
    _localStorage.delete(initialUrl);
    _internetConnectionSubscription?.cancel();
    _checkInternetUseCase.dispose();
    _logs.close();
    super.onClose();
  }
}
