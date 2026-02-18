import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:user_account/src/presentation/delete_account_confirmation/delete_account_confirmation.dart';

class DeleteAccountConfirmationBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<DeleteUserUseCase>(
      DeleteUserUseCaseImpl(
        userService: AppBinding.find(),
        authStorageUseCase: AppBinding.find(),
      ),
    );

    AppBinding.put<DeleteAccountConfirmationController>(
      DeleteAccountConfirmationController(
        deleteUserUseCase: AppBinding.find(),
        userAuthStorageUseCase: AppBinding.find(),
        deleteAccountStore: AppBinding.find(),
        appSecurityManager: AppBinding.find(),
      ),
    );
  }
}
