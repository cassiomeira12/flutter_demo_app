import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final bool hasSession = AppBinding.hasInstance<SessionEntity>();
    if (!hasSession) {
      return RouteSettings(name: AppRouter.splash.name);
    }

    final bool hasUser = AppBinding.hasInstance<UserEntity>();
    if (!hasUser) {
      if (route != AppRouter.login.name) {
        final loginRouter = AppRoutes.findByRoute(AppRouter.login.name);
        if (loginRouter == null) {
          return RouteSettings(name: AppRouter.home.name);
        }
        return RouteSettings(name: AppRouter.login.name);
      }
      return null;
    }

    final user = AppBinding.find<UserEntity>();
    if (user.permissions.contains(UserPermissionsEnum.ADMIN)) {
      if (route != AppRouter.admin.name) {
        return RouteSettings(name: AppRouter.admin.name);
      }
    } else {
      if (route != AppRouter.home.name) {
        return RouteSettings(name: AppRouter.home.name);
      }
    }
    return null;
  }
}
