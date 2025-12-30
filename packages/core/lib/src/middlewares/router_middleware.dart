import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class RouterMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final pageRouter = AppRoutes.findByRoute(route ?? '');
    if (pageRouter == null) {
      Log.warning('Router: $route not found');
      return RouteSettings(name: AppRouter.unknown.name);
    }
    return null;
  }
}
