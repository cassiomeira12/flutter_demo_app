import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:security/src/presentation/presentation.dart';

class SecurityModuleSubRoutes implements ModuleRoutes {
  @override
  List<AppRouterPage> get pages => [
    AppRouterPage(
      name: AppRouter.security.name,
      page: SecurityPage.new,
      binding: SecurityBindings(),
      transition: Transition.noTransition,
    ),
  ];
}
