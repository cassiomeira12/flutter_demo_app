import 'package:get/get.dart';

import 'settings_controller.dart';

class SettingsBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<SettingsController>(
      SettingsController(),
    );
  }
}
