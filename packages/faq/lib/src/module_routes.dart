import 'package:core/core.dart';

import 'presentation/presentation.dart';

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
