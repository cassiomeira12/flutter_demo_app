import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'presentation/presentation.dart';

class SplashModuleRoutes implements ModuleRoutes {
  @override
  List<AppRouterPage> get pages => [
    AppRouterPage(
      name: AppRouter.unknown.name,
      page: UnknownPage.new,
      binding: UnknownBindings(),
    ),
    AppRouterPage(
      name: AppRouter.splash.name,
      page: SplashPage.new,
      binding: SplashBindings(),
      transition: Transition.noTransition,
    ),
  ];
}
