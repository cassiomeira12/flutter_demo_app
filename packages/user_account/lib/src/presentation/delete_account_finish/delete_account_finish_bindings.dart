import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:user_account/src/presentation/delete_account_finish/delete_account_finish.dart';

class DeleteAccountFinishBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<DeleteAccountFinishController>(
      DeleteAccountFinishController(),
    );
  }
}
