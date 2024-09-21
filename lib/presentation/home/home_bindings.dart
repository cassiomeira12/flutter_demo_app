import '../../core/core.dart';
import 'home_controller.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<HomeController>(
      HomeController(),
      //fenix: true,
    );
    // Get.create(() => HomeController());
  }
}
