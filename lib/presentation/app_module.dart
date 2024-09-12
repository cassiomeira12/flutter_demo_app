import 'package:get/get.dart';

import 'app_router.dart';
import 'contacts/contacts.dart';
import 'emergency/emergency.dart';
import 'home/home.dart';
import 'login/login.dart';
import 'settings/settings.dart';
import 'splash/spash.dart';

abstract class AppModule {
  static List<GetPage> routes = [
    GetPage(
      name: AppRouter.splash.name,
      page: () => const SplashPage(),
      binding: SplashBindings(),
    ),
    GetPage(
      name: AppRouter.login.name,
      page: () => LoginPage(),
      binding: LoginBindings(),
    ),
    GetPage(
      name: AppRouter.home.name,
      page: () => HomePage(),
      binding: HomeBindings(),
    ),
    ...EmergencyModule.routes,
    ...ContactsModule.routes,
    ...SettingsModule.routes,
  ];
}
