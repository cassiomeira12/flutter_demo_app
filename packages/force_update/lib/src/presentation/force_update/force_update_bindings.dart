import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:force_update/src/presentation/force_update/force_update.dart';

class ForceUpdateBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<ForceUpdateController>(
      ForceUpdateController(
        appInfoEntity: AppBinding.find(),
        openWebUrlUseCase: AppBinding.find(),
      ),
    );
  }
}
