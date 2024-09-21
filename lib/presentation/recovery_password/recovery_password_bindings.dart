import '../../core/core.dart';
import 'recovery_password_controller.dart';

class RecoveryPasswordBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<RecoveryPasswordController>(
      RecoveryPasswordController(),
    );
  }
}
