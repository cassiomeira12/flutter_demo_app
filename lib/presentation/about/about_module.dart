import '../../core/core.dart';
import '../app_router.dart';
import 'about_bindings.dart';
import 'about_page.dart';

abstract class AboutModule {
  static List<AppRouterPage> routes = [
    AppRouterPage(
      name: AppRouter.about.name,
      page: () => AboutPage(),
      binding: AboutBindings(),
      preventDuplicates: false,
    ),
  ];
}
