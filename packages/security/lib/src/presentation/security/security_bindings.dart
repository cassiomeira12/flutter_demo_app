import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import '../../data/data.dart';
import '../../domain/domain.dart';
import 'security.dart';

class SecurityBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<LocalAuthService>(LocalAuthServiceImpl());
    AppBinding.put<CheckBiometricsUseCase>(
      CheckBiometricsUseCaseImpl(localAuthService: AppBinding.find()),
    );
    AppBinding.put<AuthenticateBiometricUseCase>(
      AuthenticateBiometricUseCaseImpl(localAuthService: AppBinding.find()),
    );

    AppBinding.put<SecurityController>(
      SecurityController(
        localStorageUseCase: AppBinding.find(),
        checkBiometricsUseCase: AppBinding.find(),
        authenticateBiometricUseCase: AppBinding.find(),
        logoutUseCase: AppBinding.find(),
        pushMessagingService: AppBinding.find(),
        appSecurityManager: AppBinding.find(),
      ),
    );
  }
}
