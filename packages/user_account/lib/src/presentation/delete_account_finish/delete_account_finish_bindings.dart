import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'delete_account_finish.dart';

class DeleteAccountFinishBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<DeleteAccountFinishController>(
      DeleteAccountFinishController(),
    );
  }
}
