import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:force_update/src/presentation/update/update.dart';

class UpdateBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<UpdateController>(
      UpdateController(
        appInfoEntity: AppBinding.find(),
        currentDeviceLocaleUseCase: AppBinding.find(),
        openWebUrlUseCase: AppBinding.find(),
      ),
    );
  }
}
