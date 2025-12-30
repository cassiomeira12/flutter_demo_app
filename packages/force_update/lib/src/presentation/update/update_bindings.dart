import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'update.dart';

class UpdateBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<UpdateController>(
      UpdateController(
        appInfoEntity: AppBinding.find(),
        localStorageUseCase: AppBinding.find(),
        featureFlagService: AppBinding.find(),
        pushMessagingService: AppBinding.find(),
        openWebUrlUseCase: AppBinding.find(),
      ),
    );
  }
}
