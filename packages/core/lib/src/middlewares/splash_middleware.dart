import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class SplashMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (AppRouter.splash.name == route ||
        BaseController.SPLASH_ALREADY_EXECUTED) {
      return null;
    }
    return RouteSettings(name: AppRouter.splash.name);
  }
}
