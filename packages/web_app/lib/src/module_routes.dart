import 'package:core/core.dart';
import 'package:web_app/src/presentation/web/web.dart';

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
