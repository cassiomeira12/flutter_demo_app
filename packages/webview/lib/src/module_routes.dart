import 'package:core/core.dart';

import 'presentation/presentation.dart';

class WebViewModuleRoutes implements ModuleRoutes {
  @override
  List<AppRouterPage> get pages => [
    AppRouterPage(
      name: AppRouter.webview.name,
      page: () => WebViewPage(
        urlParams: {
          'uol_app': 'placaruol',
          'app_capabilities': 'init-metrics,comments',
          'anchorAds': 'true',
        },
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
