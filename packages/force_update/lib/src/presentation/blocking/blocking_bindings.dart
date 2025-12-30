import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'blocking.dart';

class BlockingBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<BlockingController>(
      BlockingController(
        localStorageUseCase: AppBinding.find(),
        appInfoEntity: AppBinding.find(),
        checkPermissionUseCase: AppBinding.find(),
        pushMessagingService: AppBinding.find(),
        featureFlagService: AppBinding.find(),
        appSecurityManager: AppBinding.find(),
      ),
    );
  }
}
