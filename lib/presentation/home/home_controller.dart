import 'package:flutter_demo_app/presentation/app_router.dart';
import 'package:get/get.dart';

import '../../core/core.dart';
import '../../design_system/design_system.dart';

class HomeController extends BaseController {
  RxnInt id = RxnInt();

  @override
  void onReady() {
    id.value = Get.arguments as int?;
    if (id.value == null) {
      Get.offAllNamed(AppRouter.splash.route);
    }
    super.onReady();
  }

  void teste(String theme) {
    Get.find<ThemeController>().changeTheme(theme);
  }
}
