import 'package:dependency/dependency.dart';
import 'package:webview/src/presentation/widgets/web_view/webview_widget_controller.dart';

mixin LoadCallbacksExtension {
  void onWebViewCreated(
    String url, {
    required WebViewWidgetController webViewController,
    required void Function(bool isLoading) loading,
    required void Function(String log) onLog,
  }) {
    onLog('onWebViewCreated $url');
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

    if (progress > webViewController.lastProgress) {
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
    onLog('onPageCommitVisible ${webViewController.lastProgress}%');

    if (webUri == null || webUri.toString().contains('about:blank')) {
      onLog('processGone onPageCommitVisible url about:blank');
      processGone();
      return;
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
      processGone();
      return;
    }

    webViewController.nextStep();
    webViewController.setCurrentUri(webUri.uriValue);
  }
}
