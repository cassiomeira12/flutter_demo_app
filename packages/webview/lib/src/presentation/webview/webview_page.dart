// ignore_for_file: must_be_immutable

import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import '../../domain/domain.dart';
import '../widgets/web_view/webview_widget.dart';
import 'webview.dart';

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
        reloadExpiredUrls: [
          ReloadExpiredUrlEntity(
            enable: true,
            pattern: RegExp(
              r'^https:\/\/www\.uol\.com\.br\/esporte\/futebol\/times\/.*$',
            ),
            expiredTime: Duration(minutes: 5),
          ),
          ReloadExpiredUrlEntity(
            enable: true,
            pattern: RegExp(
              r'^https:\/\/www\.uol\.com\.br\/esporte\/futebol\/central-de-jogos\/.*$',
            ),
            expiredTime: Duration(minutes: 5),
          ),
          ReloadExpiredUrlEntity(
            enable: true,
            pattern: RegExp(
              r'^https:\/\/placar\.uol\.com\.br\/esporte\/futebol\/.*$',
            ),
            expiredTime: Duration(seconds: 1),
          ),
          ReloadExpiredUrlEntity(
            enable: true,
            pattern: RegExp(
              r'^https:\/\/www\.uol\.com\.br\/flash\/esporte\/.*$',
            ),
            expiredTime: Duration(minutes: 10),
          ),
          ReloadExpiredUrlEntity(
            enable: true,
            pattern: RegExp(r'^https:\/\/www\.uol\.com\.br\/?$'),
            expiredTime: Duration(minutes: 30),
          ),
        ],
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
    final arguments = AppNavigator.arguments as Map<String, dynamic>? ?? {};
    url = widget.url ?? arguments['url'] ?? '';
    controller.url = url;
    if (url.isEmpty) {
      controller.errorMessage.value = 'Url empty';
      controller.setError(true);
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
              if (showWebView) {
                return WebViewWidget(
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
                    controller.errorMessage.value =
                        error ?? 'Sem mensagem de erro';
                    controller.setError(true);
                    if (!isNetworkError) {
                      Log.error(
                        'WebView Error: $error',
                        error: Exception(error),
                      );
                    }
                  },
                  onSaveScroll: controller.updateScrollPosition,
                  processGone: () => controller.setProcessGone(true),
                  onLog: controller.addLog,
                  openExternalLink: controller.openExternalLink,
                  noInternetConnectionCallback:
                      controller.noInternetConnectionCallback,
                );
              }
              return const SizedBox.shrink();
            },
          ),
          ValueListenableBuilder<bool>(
            valueListenable: controller.isLoadingValue,
            builder: (BuildContext context, bool isLoading, child) {
              if (isLoading) {
                return widget.skeletonWidget ?? const SkeletonWidget();
              }
              return const SizedBox.shrink();
            },
          ),
          ValueListenableBuilder<bool>(
            valueListenable: controller.hasErrorValue,
            builder: (BuildContext context, bool hasError, child) {
              if (controller.hasError) {
                return ErrorPage(
                  errorMessage: controller.errorMessage.value,
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
                      children: [
                        FutureButton(
                          text: 'Compartilhar',
                          onPressed: controller.shareLogs,
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
