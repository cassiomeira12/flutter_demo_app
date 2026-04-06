import 'package:core/core.dart';
import 'package:webview/src/domain/domain.dart';
import 'package:webview/src/presentation/webview/webview.dart';

class WebViewModuleRoutes implements ModuleRoutes {
  @override
  List<AppRouterPage> get pages => [
    AppRouterPage(
      name: AppRouter.webview.name,
      page: () => WebViewPage(
        urlParams: const {
          'uol_app': 'placaruol',
          'app_capabilities': 'init-metrics,comments',
          'anchorAds': 'true',
        },
        reloadExpiredUrls: [
          ReloadExpiredUrlEntity(
            enable: true,
            pattern: RegExp(
              r'^https:\/\/www\.uol\.com\.br\/esporte\/futebol\/times\/.*$',
            ),
            expiredTime: const Duration(minutes: 5),
          ),
          ReloadExpiredUrlEntity(
            enable: true,
            pattern: RegExp(
              r'^https:\/\/www\.uol\.com\.br\/esporte\/futebol\/central-de-jogos\/.*$',
            ),
            expiredTime: const Duration(minutes: 5),
          ),
          ReloadExpiredUrlEntity(
            enable: true,
            pattern: RegExp(
              r'^https:\/\/placar\.uol\.com\.br\/esporte\/futebol\/.*$',
            ),
            expiredTime: const Duration(seconds: 1),
          ),
          ReloadExpiredUrlEntity(
            enable: true,
            pattern: RegExp(
              r'^https:\/\/www\.uol\.com\.br\/flash\/esporte\/.*$',
            ),
            expiredTime: const Duration(minutes: 10),
          ),
          ReloadExpiredUrlEntity(
            enable: true,
            pattern: RegExp(r'^https:\/\/www\.uol\.com\.br\/?$'),
            expiredTime: const Duration(minutes: 30),
          ),
        ],
        openPage: (String url) async {
          await AppNavigator.toNamed(
            AppRouter.webview,
            arguments: {'url': url},
          );
        },
      ),
    ),
  ];
}
