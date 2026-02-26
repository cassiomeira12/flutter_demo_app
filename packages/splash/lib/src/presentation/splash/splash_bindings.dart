import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:splash/src/presentation/splash/splash.dart';

class SplashBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<SplashController>(
      SplashController(
        firebaseInitializeService: AppBinding.find(),
        getUserDataUseCase: AppBinding.find(),
        localStorageUseCase: AppBinding.find(),
        sessionEntity: AppBinding.find(),
        appInfoEntity: AppBinding.find(),
        checkPermissionUseCase: AppBinding.find(),
        pushMessagingService: AppBinding.find(),
        pushNotificationsService: AppBinding.find(),
        getDeviceLocaleUseCase: AppBinding.find(),
        appsFlyerService: AppBinding.find(),
        appSecurityManager: AppBinding.find(),
        getInstallationAppUseCase: AppBinding.find(),
        uploadInstallationAppUseCase: AppBinding.find(),
        featureFlagLifecycleController: AppBinding.find(),
      ),
    );
  }
}
