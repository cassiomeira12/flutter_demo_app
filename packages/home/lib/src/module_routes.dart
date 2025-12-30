import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'presentation/presentation.dart';

class HomeModuleRoutes implements ModuleRoutes {
  @override
  List<AppRouterPage> get pages => [
    AppRouterPage(
      name: AppRouter.home.name,
      page: HomePage.new,
      binding: HomeBindings(),
      // middlewares: [AuthMiddleware()],
      transition: Transition.noTransition,
    ),
  ];
}
