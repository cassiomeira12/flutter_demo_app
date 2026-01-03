import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'web_controller.dart';

class WebBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<WebController>(
      WebController(
        openWebUrlUseCase: AppBinding.find(),
        currentDeviceLocaleUseCase: AppBinding.find(),
      ),
    );
  }
}
