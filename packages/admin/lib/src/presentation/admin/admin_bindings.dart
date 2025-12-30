import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'admin.dart';

class AdminBindings extends Bindings {
  @override
  void dependencies() {
    // AppBinding.put<NotificationsStore>(NotificationsStore());

    AppBinding.put<AdminController>(
      AdminController(
        // getUserDataUseCase: AppBinding.find(),
        // openWebUrlUseCase: AppBinding.find(),
        logoutUseCase: AppBinding.find(),
        localStorageUseCase: AppBinding.find(),
        pushMessagingService: AppBinding.find(),
        appSecurityManager: AppBinding.find(),
      ),
    );
  }
}
