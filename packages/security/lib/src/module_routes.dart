import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:security/src/presentation/presentation.dart';

class SecurityModuleRoutes implements ModuleRoutes {
  @override
  List<AppRouterPage> get pages => [
    AppRouterPage(
      canPop: false,
      name: AppRouter.securityBlocked.name,
      page: SecurityBlockedPage.new,
      binding: SecurityBindings(),
      transition: Transition.noTransition,
    ),
  ];
}
