import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:user_account/src/presentation/presentation.dart';

class DeleteAccountBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<DeleteAccountStore>(DeleteAccountStore());

    AppBinding.put<DeleteAccountController>(
      DeleteAccountController(deleteAccountStore: AppBinding.find()),
    );
  }
}
