import 'package:get/get.dart';

import 'app_router.dart';
import 'home/home.dart';
import 'splash/spash.dart';

abstract class AppModule {
  static List<GetPage> routes = [
    GetPage(
      name: AppRouter.splash.route,
      page: () => const SplashPage(),
      binding: SplashBindings(),
    ),
    GetPage(
      name: AppRouter.home.route,
      page: () => HomePage(),
      binding: HomeBindings(),
      preventDuplicates: false,
    ),
  ];
}
