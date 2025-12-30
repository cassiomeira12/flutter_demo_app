import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'splash.dart';

class SplashBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<SplashController>(
      SplashController(
        firebaseInitializeService: AppBinding.find(),
        getUserDataUseCase: AppBinding.find(),
        localStorageUseCase: AppBinding.find(),
        authStorageUseCase: AppBinding.find(),
        getAppInfoUseCase: AppBinding.find(),
        getDeviceInfoUseCase: AppBinding.find(),
        checkPermissionUseCase: AppBinding.find(),
        featureFlagService: AppBinding.find(),
        pushMessagingService: AppBinding.find(),
        pushNotificationsService: AppBinding.find(),
        getDeviceLocaleUseCase: AppBinding.find(),
        appsFlyerService: AppBinding.find(),
        themeController: AppBinding.find(),
        appSecurityManager: AppBinding.find(),
      ),
    );
  }
}
