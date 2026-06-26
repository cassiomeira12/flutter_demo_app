import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:user_account/src/presentation/presentation.dart';

class DeleteAccountConfirmationBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<DeleteAccountConfirmationController>(
      DeleteAccountConfirmationController(
        deleteUserUseCase: AppBinding.find(),
        userAuthStorageUseCase: AppBinding.find(),
        deleteAccountStore: AppBinding.find(),
        appSecurityManager: AppBinding.find(),
        userEntity: AppBinding.find(),
      ),
    );
  }
}
