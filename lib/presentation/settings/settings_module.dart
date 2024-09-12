import 'package:get/get.dart';

import '../app_router.dart';
import 'settings_bindings.dart';
import 'settings_page.dart';

abstract class SettingsModule {
  static List<GetPage> routes = [
    GetPage(
      name: AppRouter.settings.name,
      page: () => SettingsPage(),
      binding: SettingsBindings(),
    ),
  ];
}
