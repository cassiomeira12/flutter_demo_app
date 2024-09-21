import '../../core/core.dart';
import '../about/about.dart';
import '../app_router.dart';
import 'settings_bindings.dart';
import 'settings_page.dart';

abstract class SettingsModule {
  static List<AppRouterPage> routes = [
    AppRouterPage(
      name: AppRouter.settings.name,
      page: () => SettingsPage(),
      binding: SettingsBindings(),
      children: [
        ...AboutModule.routes,
      ],
    ),
  ];
}
