import 'package:core/core.dart';

import 'presentation/presentation.dart';

class WebAppModuleRoutes implements ModuleRoutes {
  @override
  List<AppRouterPage> get pages => [
    AppRouterPage(
      name: AppRouter.web.name,
      page: WebPage.new,
      binding: WebBindings(),
    ),
  ];
}
