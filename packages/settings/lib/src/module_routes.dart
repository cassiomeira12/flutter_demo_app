import 'package:core/core.dart';
import 'package:security/security.dart';
import 'package:settings/src/presentation/presentation.dart';

class SettingsModuleRoutes implements ModuleRoutes {
  @override
  List<AppRouterPage> get pages => [
    AppRouterPage(
      name: AppRouter.settings.name,
      page: () => const SettingsPage(),
      binding: SettingsBindings(),
      children: [
        // ...UserAccountModuleSubRoutes().pages,
        ...SecurityModuleSubRoutes().pages,
        // ...FaqModuleRoutes().pages,
        ...AppThemesModuleRoutes().pages,
      ],
    ),
  ];
}
