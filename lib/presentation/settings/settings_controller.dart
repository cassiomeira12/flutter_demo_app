import 'package:flutter_demo_app/presentation/app_router.dart';
import 'package:get/get.dart';

import '../../core/core.dart';
import '../../design_system/design_system.dart';

class SettingsController extends BaseController {
  void changeTheme(String theme) {
    Get.find<ThemeController>().changeTheme(theme);
  }

  void logout() {
    AppRouter.offAllNamed(AppRouter.login);
  }
}
