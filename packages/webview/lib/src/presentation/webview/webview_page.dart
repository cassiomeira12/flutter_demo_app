// ignore_for_file: must_be_immutable

import 'dart:developer' as developer;

import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:webview/src/domain/domain.dart';
import 'package:webview/src/presentation/presentation.dart';
import 'package:webview/src/presentation/webview/widgets/webview_widget.dart';

class WebViewPage extends StatefulWidget
    implements NavigatorIndexListenerCallback, TapCurrentIndexCallback {
  final String? url;
  final Map<String, String> urlParams;
  final bool hasTitle;
  final Widget? skeletonWidget;

  WebViewPage({
    super.key,
    this.url,
    this.urlParams = const {},
    this.hasTitle = true,
    List<ReloadExpiredUrlEntity> reloadExpiredUrls = const [],
    this.skeletonWidget,
    required Future<void> Function(String url) openPage,
  }) {
    controller = AppBinding.put<WebViewController>(
      WebViewController(
        globalKeyHash: globalKeyHash,
        localStorage: AppBinding.find(),
        checkInternetUseCase: AppBinding.find(),
        openWebUrlUseCase: AppBinding.find(),
        shareUseCase: AppBinding.find(),
        reloadExpiredUrls: reloadExpiredUrls,
        openPage: openPage,
      ),
      tag: globalKeyHash,
    );
  }

  final GlobalKey _webviewGlobalKey = GlobalKey();

  String get globalKeyHash {
    return _webviewGlobalKey.toString().replaceAll('GlobalKey#', '');
  }

  late WebViewController controller;

  @override
  State<WebViewPage> createState() => _WebViewPageState();

  @override
  void onChangeIndex(bool isCurrentIndex) {
    isCurrentIndex ? controller.resumeWebView() : controller.pauseWebView();
  }

  @override
  void onTap() {
    controller.addLog('onTap');
    controller.scrollToTop();
  }
}

class _WebViewPageState extends State<WebViewPage>
    with AutomaticKeepAliveClientMixin {
  late String url;

  WebViewController get controller => widget.controller;

  final String macOSUserAgent =
      'Mozilla/5.0 (iPhone; CPU iPhone like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko)';

  @override
  void initState() {
    super.initState();
    final arguments = AppNavigator.arguments;
    if (arguments is Map<String, dynamic>) {
      url = widget.url ?? arguments['url'] ?? '';
    }
    controller.initialUrl = url;
    if (url.isEmpty) {
      controller.errorMessage = 'Url empty';
      controller.setError(true);
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    developer.log('WebViewPage ${widget.globalKeyHash}', name: 'Rebuild');
    return ScaffoldWidget(
      title: widget.hasTitle ? '' : null,
      controller: controller,
      appBarPopUpMenuItems: [
        PopupMenuItem(
          onTap: () {
            controller.addLog('PopupMenuItem reload');
            controller.reloadWebView();
          },
          child: TextWidget('update'.tr),
        ),
      ],
      body: Stack(
        alignment: Alignment.center,
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: controller.showWebView,
            builder: (BuildContext context, bool showWebView, child) {
              return showWebView ? child! : const SizedBox.shrink();
            },
            child: WebViewWidget(
              globalKeyHash: widget.globalKeyHash,
              initialUrl: url,
              replaceUrl: (url) {
                final Uri uri = Uri.parse(url);
                final newUri = Uri(
                  scheme: uri.scheme,
                  host: uri.host,
                  path: uri.path,
                  queryParameters: {
                    ...uri.queryParameters,
                    ...widget.urlParams,
                  },
                );
                return newUri.toString();
              },
              userAgent: Platform.isMacOS ? macOSUserAgent : null,
              initialScrollX: controller.scrollX,
              initialScrollY: controller.scrollY,
              secondsToStartWebViewReload:
                  controller.secondsToStartWebViewReload,
              click: controller.openLink,
              loading: controller.setLoading,
              onCreateController: controller.setWebViewController,
              onError: ({required bool isNetworkError, String? error}) {
                controller.errorMessage = error ?? 'Sem mensagem de erro';
                controller.isNetworkError = isNetworkError;
                controller.setError(true);
                if (!isNetworkError) {
                  Log.error('WebView Error: $error', StackTrace.current);
                }
              },
              onSaveScroll: controller.updateScrollPosition,
              processGone: () {
                if (controller.canTryReloadAgain) {
                  // SnackBarWidget.show(
                  //   context,
                  //   title: 'slow_network_title'.tr,
                  //   message: '${'try_again'.tr}...',
                  //   backgroundColor: SemanticColors.warning300,
                  //   duration: const Duration(seconds: 3),
                  // );
                  controller.addLog('Conexão lenta, mostrar toast');
                }
                controller.setProcessGone(true);
              },
              onLog: controller.addLog,
              openExternalLink: controller.openExternalLink,
              checkInternet: controller.checkInternetConnection,
              noInternetConnectionCallback:
                  controller.showDialogNoInternetConnected,
              customNavigatorCallback:
                  AppBinding.hasInstance<CustomNavigatorCallback>()
                  ? AppBinding.find<CustomNavigatorCallback>()
                  : null,
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: controller.isLoadingValue,
            builder: (BuildContext context, bool isLoading, child) {
              if (isLoading) {
                return Column(
                  children: [
                    ValueListenableBuilder<int>(
                      valueListenable: controller.lastProgress,
                      builder: (BuildContext context, int percentage, child) {
                        return ProgressBarWidget(
                          percentage: percentage.toDouble(),
                        );
                      },
                    ),
                    Expanded(
                      child: widget.skeletonWidget ?? const SkeletonWidget(),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
          ValueListenableBuilder<bool>(
            valueListenable: controller.hasErrorValue,
            builder: (BuildContext context, bool hasError, child) {
              if (hasError) {
                if (controller.isNetworkError == true) {
                  return ErrorPage(
                    icon: Icons.wifi_off,
                    title: 'error_webview_no_network_title'.tr,
                    message: 'error_webview_no_network_message'.tr,
                    errorMessage: controller.errorMessage,
                    onTryAgain: controller.tryAgain,
                  );
                }
                return ErrorPage(
                  errorMessage: controller.errorMessage,
                  onTryAgain: controller.tryAgain,
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingButtonWidget(
        icon: FlutterIcon(
          Icons.bug_report,
          color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
        ),
        onPressed: () {
          BottomSheetWidget.show(
            context: context,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .7,
              child: Column(
                children: [
                  Expanded(
                    child: ScrollViewWidget(
                      child: (scrollController) {
                        return Obx(() {
                          return ListView.builder(
                            controller: scrollController,
                            itemCount: controller.logs.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: index == controller.logs.length - 1
                                      ? 30
                                      : 15,
                                  right: 30,
                                ),
                                child: TextWidget(controller.logs[index]),
                              );
                            },
                          );
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveSizeHelper.spacingDefaultHeight,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FutureButton(
                          text: 'Compartilhar',
                          onPressed: controller.shareLogs,
                        ),
                        SecondaryButton(
                          text: 'Limpar',
                          onPressed: controller.clearLogs,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
