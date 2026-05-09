import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:onboarding/src/presentation/intro/intro.dart';

class IntroBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<IntroController>(
      IntroController(
        appEnv: AppBinding.find(),
        requestPermissionUseCase: AppBinding.find(),
        localStorageUseCase: AppBinding.find(),
        getAppInfoUseCase: AppBinding.find(),
      ),
    );
  }
}
