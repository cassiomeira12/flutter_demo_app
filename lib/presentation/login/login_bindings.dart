import '../../core/core.dart';
import 'login_controller.dart';

class LoginBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<LoginController>(
      LoginController(
        localStorage: Get.find(),
      ),
    );
  }
}
