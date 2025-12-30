import 'package:core/core.dart';

import 'presentation/presentation.dart';

class PushMessagingModuleRoutes implements ModuleRoutes {
  @override
  List<AppRouterPage> get pages => [
    AppRouterPage(
      name: AppRouter.notificationsSettings.name,
      page: PushMessagingSettingsPage.new,
      binding: PushMessagingSettingsBindings(),
    ),
  ];
}
