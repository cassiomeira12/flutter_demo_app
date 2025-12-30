import 'package:core/core.dart';
import 'package:flutter_demo_app/presentation/emergency_history/emergency_history.dart';

abstract class EmergencyHistoryModule {
  static List<AppRouterPage> pages = [
    AppRouterPage(
      name: AppRouter.emergencyHistory.name,
      page: EmergencyHistoryPage.new,
      binding: EmergencyHistoryBindings(),
    ),
  ];
}
