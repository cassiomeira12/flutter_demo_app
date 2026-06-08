import 'dart:developer' as developer;

import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:webview/src/domain/domain.dart';
import 'package:webview/src/presentation/webview/widgets/webview_widget_controller.dart';

mixin NavigatorCallbacksMixin {
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(
    NavigationAction navAction, {
    required WebViewWidgetController webViewController,
    required void Function(String url) click,
    required void Function(String log) onLog,
    required void Function(Uri uri) openExternalLink,
    CustomNavigatorCallback? customCallbacks,
  }) async {
    final bool isMainFrame = navAction.isForMainFrame;
    final bool hasGesture = navAction.hasGesture == true;
    final bool isRedirect = navAction.isRedirect == true;
    final bool iOSGestureClicked =
        navAction.navigationType == NavigationType.LINK_ACTIVATED;
    final bool userClickedOnLink = hasGesture || iOSGestureClicked;

    final Uri? originalUri = webViewController.originalUri;
    final WebUri? uri = navAction.request.url;

    if (webViewController.isPaused) {
      onLog('shouldOverrideUrlLoading CANCEL [isPaused]');
      return NavigationActionPolicy.CANCEL;
    }

    if (webViewController.isAppInBackground) {
      onLog('shouldOverrideUrlLoading CANCEL [appBackground]');
      return NavigationActionPolicy.CANCEL;
    }

    if (!webViewController.isInternetConnected && !userClickedOnLink) {
      onLog('shouldOverrideUrlLoading CANCEL [noInternet]');
      return NavigationActionPolicy.CANCEL;
    }

    // allow load uri null or about:blank
    if (uri == null || uri.toString().startsWith('about:blank')) {
      onLog('shouldOverrideUrlLoading URL null or about:blank [ALLOW]');
      return NavigationActionPolicy.ALLOW;
    }

    final String url = uri.toString();
    final String paramsLog = navAction.toJson().toString();

    // cancel load uri javascript
    if (url.startsWith('javascript:')) {
      onLog('shouldOverrideUrlLoading URL javascript [CANCEL]');
      return NavigationActionPolicy.CANCEL;
    }

    // ignore action when URL is unsafe
    if (uri.scheme.contains('unsafe')) {
      developer.debugger();
      onLog('shouldOverrideUrlLoading Scheme Unsafe [CANCEL]');
      return NavigationActionPolicy.CANCEL;
    }

    // open external links nons http schemes
    if (!['http', 'https'].contains(uri.scheme)) {
      openExternalLink(uri);
      onLog('shouldOverrideUrlLoading openExternalLink [CANCEL]');
      return NavigationActionPolicy.CANCEL;
    }

    // allow load scripts on iOS
    if (!isMainFrame) {
      onLog('shouldOverrideUrlLoading Not MainFrame [ALLOW]');
      return NavigationActionPolicy.ALLOW;
    }

    // allow reload page
    if (navAction.navigationType == NavigationType.RELOAD) {
      onLog('shouldOverrideUrlLoading NavigationType.RELOAD [ALLOW]');
      return NavigationActionPolicy.ALLOW;
    }

    final Uri? lastUriLoaded = await webViewController.currentUri;

    final bool uriEqualsOriginalUri = UriHelper.equals(originalUri, uri);
    final bool uriEqualsLastLoadedUri = UriHelper.equals(lastUriLoaded, uri);
    final bool isSubRoute = UriHelper.isSubRoute(lastUriLoaded, uri);

    // allow load if uri is equals the begging or current
    if (uriEqualsOriginalUri || uriEqualsLastLoadedUri) {
      onLog('shouldOverrideUrlLoading current Url equals Last [ALLOW]');
      // HapticFeedback.lightImpact();
      return NavigationActionPolicy.ALLOW;
    }

    // custom actions
    final NavigationActionPolicy? customAction = await customCallbacks?.call(
      navAction,
      click,
      onLog,
      isRedirect: isRedirect,
      hasGesture: hasGesture,
      userClicked: userClickedOnLink,
      uri: uri,
    );

    if (customAction != null) return customAction;

    if (isSubRoute) {
      if (UriHelper.isDirectSubRoute(lastUriLoaded, uri)) {
        onLog('shouldOverrideUrlLoading DirectSubRoute [ALLOW]');
        // HapticFeedback.lightImpact();
        return NavigationActionPolicy.ALLOW;
      }
    }

    // load uri when is redirect
    if (!hasGesture && isRedirect) {
      // ex: https://www.uol.com.br/esporte/mma
      onLog('shouldOverrideUrlLoading loadUrl $paramsLog [CANCEL]');
      webViewController.loadUrl(uri);
      return NavigationActionPolicy.CANCEL;
    }

    if (userClickedOnLink) {
      click(url);
      onLog('shouldOverrideUrlLoading click [CANCEL] $paramsLog');
      return NavigationActionPolicy.CANCEL;
    }

    onLog('shouldOverrideUrlLoading final [ALLOW] $paramsLog');

    return NavigationActionPolicy.ALLOW;
  }

  Timer? _multipleIgnoreCallsTimer;

  void onScrollChanged({
    required int x,
    required int y,
    required void Function(int x, int y) onSaveScroll,
  }) {
    if (_multipleIgnoreCallsTimer?.isActive ?? false) {
      _multipleIgnoreCallsTimer?.cancel();
    }
    _multipleIgnoreCallsTimer = Timer(const Duration(seconds: 1), () {
      onSaveScroll(x, y);
    });
  }
}
