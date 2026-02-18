import 'package:core/core.dart';
import 'package:push_messaging/src/presentation/push_messaging_settings/push_messaging_settings.dart';

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
