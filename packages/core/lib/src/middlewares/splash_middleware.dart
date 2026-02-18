import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class SplashMiddleware extends GetMiddleware {
  final List<String> _ignore = [AppRouter.initial.name, AppRouter.splash.name];

  @override
  RouteSettings? redirect(String? route) {
    if (_ignore.contains(route) || BaseController.SPLASH_ALREADY_EXECUTED) {
      return null;
    }
    return RouteSettings(name: AppRouter.initial.name);
  }
}
