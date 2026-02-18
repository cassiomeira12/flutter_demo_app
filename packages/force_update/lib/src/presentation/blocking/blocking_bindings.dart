import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:force_update/src/presentation/blocking/blocking.dart';

class BlockingBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<BlockingController>(
      BlockingController(
        localStorageUseCase: AppBinding.find(),
        appInfoEntity: AppBinding.find(),
        checkPermissionUseCase: AppBinding.find(),
        pushMessagingService: AppBinding.find(),
      ),
    );
  }
}
