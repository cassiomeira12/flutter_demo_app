import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'settings.dart';

class SettingsBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<SettingsController>(
      SettingsController(
        themeController: AppBinding.find(),
        logoutUseCase: AppBinding.find(),
        localStorageUseCase: AppBinding.find(),
        userAuthStorageUseCase: AppBinding.find(),
        updateUserLocaleUseCase: AppBinding.find(),
        pushMessagingService: AppBinding.find(),
        appInfoEntity: AppBinding.find(),
        appSecurityManager: AppBinding.find(),
      ),
    );
  }
}
