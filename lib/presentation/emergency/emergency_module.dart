import 'package:core/core.dart';
import 'package:flutter_demo_app/presentation/emergency/emergency.dart';
import 'package:flutter_demo_app/presentation/emergency_history/emergency_history.dart';

abstract class EmergencyModule {
  static List<AppRouterPage> pages = [
    AppRouterPage(
      name: AppRouter.emergency.name,
      page: () => const EmergencyPage(),
      binding: EmergencyBindings(),
      children: [
        ...EmergencyHistoryModule.pages,
        // ...NotificationsModule.pages,
      ],
    ),
  ];
}
