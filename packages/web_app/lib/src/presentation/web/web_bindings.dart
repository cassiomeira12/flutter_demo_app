import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:web_app/src/presentation/web/web.dart';

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
