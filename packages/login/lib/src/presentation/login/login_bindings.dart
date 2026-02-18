import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:login/src/presentation/login/login.dart';

class LoginBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<LoginController>(
      LoginController(
        environment: AppBinding.find(),
        loginUseCase: AppBinding.find(),
        localStorageUseCase: AppBinding.find(),
        authStorageUseCase: AppBinding.find(),
        updateUserLocaleUseCase: AppBinding.find(),
        uploadInstallationAppUseCase: AppBinding.find(),
        appInfoEntity: AppBinding.find(),
      ),
    );
  }
}
