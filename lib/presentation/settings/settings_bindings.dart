import '../../core/core.dart';
import 'settings_controller.dart';

class SettingsBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<SettingsController>(
      SettingsController(
        themeController: Get.find(),
        localStorage: Get.find(),
      ),
    );
  }
}
