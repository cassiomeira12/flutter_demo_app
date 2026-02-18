import 'package:admin/src/presentation/admin/admin.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

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
