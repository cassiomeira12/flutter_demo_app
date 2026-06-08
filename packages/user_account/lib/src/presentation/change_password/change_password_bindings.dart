import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:user_account/src/domain/domain.dart';
import 'package:user_account/src/presentation/change_password/change_password.dart';

class ChangePasswordBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<ChangePasswordUseCase>(
      ChangePasswordUseCaseImpl(
        userService: AppBinding.find(),
        encryptUserPasswordUseCase: AppBinding.find(),
        userAuthStorageUseCase: AppBinding.find(),
        encryptServerPublicKeyUseCase: AppBinding.find(),
      ),
    );

    AppBinding.put<ChangePasswordController>(
      ChangePasswordController(changePasswordUseCase: AppBinding.find()),
    );
  }
}
