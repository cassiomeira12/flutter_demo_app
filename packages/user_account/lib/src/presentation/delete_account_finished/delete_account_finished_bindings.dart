import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'delete_account_finished.dart';

class DeleteAccountFinishedBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<DeleteAccountFinishedController>(
      DeleteAccountFinishedController(),
    );
  }
}
