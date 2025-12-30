import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'presentation/presentation.dart';

class LoginModuleRoutes implements ModuleRoutes {
  @override
  List<AppRouterPage> get pages => [
    AppRouterPage(
      name: AppRouter.login.name,
      page: LoginPage.new,
      binding: LoginBindings(),
      transition: Transition.noTransition,
    ),
    AppRouterPage(
      name: AppRouter.recoveryPassword.name,
      page: RecoveryPasswordPage.new,
      binding: RecoveryPasswordBindings(),
    ),
    AppRouterPage(
      name: AppRouter.signup.name,
      page: () => SignUpPage(),
      binding: SignUpBindings(),
    ),
  ];
}
