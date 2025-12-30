import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'intro.dart';

class IntroBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<IntroController>(
      IntroController(
        requestPermissionUseCase: AppBinding.find(),
        localStorageUseCase: AppBinding.find(),
        getAppInfoUseCase: AppBinding.find(),
      ),
    );
  }
}
