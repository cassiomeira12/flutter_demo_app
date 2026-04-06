import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:faq/faq.dart';
import 'package:security/security.dart';
import 'package:settings/src/presentation/presentation.dart';
import 'package:user_account/user_account.dart';

class SettingsModuleRoutes implements ModuleRoutes {
  @override
  List<AppRouterPage> get pages => [
    AppRouterPage(
      name: AppRouter.settings.name,
      page: () => const SettingsPage(),
      binding: SettingsBindings(),
      transition: Transition.noTransition,
      children: [
        ...UserAccountModuleSubRoutes().pages,
        ...SecurityModuleSubRoutes().pages,
        ...FaqModuleRoutes().pages,
        ...AppThemesModuleRoutes().pages,
      ],
    ),
  ];
}
