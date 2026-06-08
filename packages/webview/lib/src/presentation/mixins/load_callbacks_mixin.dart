import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:webview/src/presentation/webview/widgets/webview_widget_controller.dart';

mixin LoadCallbacksMixin {
  TrackOperation? onCreatedTrack;
  TrackOperation? onPageCommitTrack;

  void onWebViewCreated(
    String? url, {
    required WebViewWidgetController webViewController,
    required void Function(bool isLoading) loading,
    required void Function(String log) onLog,
  }) {
    onCreatedTrack = webViewController.startOnCreatedWebViewTrack();
    onLog('onWebViewCreated url: $url');
    loading(true);
    webViewController.nextStep();
    webViewController.startLoadingTimer();
  }

  void onLoadStart(
    WebUri? webUri, {
    required WebViewWidgetController webViewController,
    required void Function(String log) onLog,
  }) {
    webViewController.clearLoadingManager();
    if (!webViewController.currentStep.isOnLoadStartedStep) return;

    onCreatedTrack?.finish();

    webViewController.startTrackPerformance(webUri);

    webViewController.startOnStartLoadingTrack();
    onPageCommitTrack = webViewController.trackPerformance?.startChild(
      name: 'webview-on-page-commit-track',
    );

    onLog('onLoadStart $webUri');
    webViewController.nextStep();
    webViewController.startLoadingTimer();
    webViewController.setCurrentUri(webUri?.uriValue);
  }

  void onProgressChanged(
    int progress, {
    required WebViewWidgetController webViewController,
    required void Function(String log) onLog,
  }) {
    if (!webViewController.currentStep.isGreaterThanProgressStep) return;

    if (progress > webViewController.lastProgress.value) {
      if (webViewController.currentStep.isGreaterThanProgressStep) {
        onLog('onProgressChanged $progress% ⏳');
        webViewController.setProgress(progress);
        webViewController.startLoadingTimer();
      }
      if (webViewController.currentStep.isOnProgressChangedStep) {
        webViewController.nextStep();
      }
    }
  }

  void onPageCommitVisible(
    WebUri? webUri, {
    required WebViewWidgetController webViewController,
    required void Function(String log) onLog,
    required void Function() processGone,
  }) {
    onLog('onPageCommitVisible ${webViewController.lastProgress.value}% ⏳');

    onPageCommitTrack?.finish();

    if (webUri == null || webUri.toString().contains('about:blank')) {
      onLog('processGone onPageCommitVisible url about:blank');
      webViewController.finishTrackPerformance(
        error: 'onPageCommitVisible url about:blank',
        status: TrackOperationStatus.dataLoss,
      );
      return processGone();
    }

    webViewController.nextStep();
    webViewController.setCurrentUri(webUri.uriValue);
    webViewController.startLoadingTimer();
  }

  void onLoadStop(
    WebUri? webUri, {
    required WebViewWidgetController webViewController,
    required void Function(String log) onLog,
    required void Function() processGone,
  }) {
    if (!webViewController.currentStep.isGreaterThanProgressStep) return;
    onLog('onLoadStop $webUri');

    if (webUri == null || webUri.toString().contains('about:blank')) {
      onLog('processGone onLoadStop url about:blank');
      webViewController.finishTrackPerformance(
        error: 'onLoadStop url about:blank',
        status: TrackOperationStatus.dataLoss,
      );
      return processGone();
    }

    webViewController.nextStep();
    webViewController.setCurrentUri(webUri.uriValue);
    webViewController.finishFullLoadingTracking();
  }
}
