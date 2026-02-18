import 'package:core/core.dart';
import 'package:faq/src/presentation/about/about.dart';

class FaqModuleRoutes implements ModuleRoutes {
  @override
  List<AppRouterPage> get pages => [
    AppRouterPage(
      name: AppRouter.about.name,
      page: AboutPage.new,
      binding: AboutBindings(),
    ),
  ];
}
