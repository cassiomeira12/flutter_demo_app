import '../../core/core.dart';
import 'signup_controller.dart';

class SignUpBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<SignUpController>(
      SignUpController(),
    );
  }
}
