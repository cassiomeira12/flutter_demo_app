import 'package:core/core.dart';
import 'package:user_account/src/presentation/presentation.dart';

class UserAccountModuleSubRoutes implements ModuleRoutes {
  @override
  List<AppRouterPage> get pages => [
    AppRouterPage(
      name: AppRouter.user.name,
      page: UserPage.new,
      binding: UserBindings(),
    ),
    AppRouterPage(
      name: AppRouter.changePassword.name,
      page: ChangePasswordPage.new,
      binding: ChangePasswordBindings(),
    ),
  ];
}
