import 'package:get/get.dart';

import '../app_router.dart';
import 'emergency_bindings.dart';
import 'emergency_page.dart';

abstract class EmergencyModule {
  static List<GetPage> routes = [
    GetPage(
      name: AppRouter.emergency.name,
      page: () => EmergencyPage(),
      binding: EmergencyBindings(),
      preventDuplicates: false,
    ),
  ];
}
