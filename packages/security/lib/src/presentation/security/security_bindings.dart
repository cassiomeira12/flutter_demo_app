import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:security/src/data/data.dart';
import 'package:security/src/domain/domain.dart';
import 'package:security/src/presentation/security/security.dart';

class SecurityBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<LocalAuthService>(
      LocalAuthServiceImpl(),
    );

    AppBinding.put<CheckBiometricsUseCase>(
      CheckBiometricsUseCase(
        localAuthService: AppBinding.find(),
      ),
    );
    AppBinding.put<AuthenticateBiometricUseCase>(
      AuthenticateBiometricUseCase(
        localAuthService: AppBinding.find(),
      ),
    );

    AppBinding.put<SecurityController>(
      SecurityController(
        localStorageUseCase: AppBinding.find(),
        checkBiometricsUseCase: AppBinding.find(),
        authenticateBiometricUseCase: AppBinding.find(),
        logoutUseCase: AppBinding.find(),
        appSecurityManager: AppBinding.find(),
      ),
    );
  }
}
