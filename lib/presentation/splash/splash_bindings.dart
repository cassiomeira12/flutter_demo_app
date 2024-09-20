import '../../core/core.dart';
import 'splash_controller.dart';

class SplashBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<SplashController>(
      SplashController(),
    );
  }
}
