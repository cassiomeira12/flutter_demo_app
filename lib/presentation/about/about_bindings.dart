import '../../core/core.dart';
import 'about_controller.dart';

class AboutBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<AboutController>(
      AboutController(),
    );
  }
}
