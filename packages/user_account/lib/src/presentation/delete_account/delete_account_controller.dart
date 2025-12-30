import 'package:core/core.dart';

import 'delete_account.dart';

class DeleteAccountController extends BaseController {
  final DeleteAccountStore _deleteAccountStore;

  DeleteAccountController({required DeleteAccountStore deleteAccountStore})
    : _deleteAccountStore = deleteAccountStore;

  String? get reason => _deleteAccountStore.selectedReason.value;

  void setReason(String? reason) {
    _deleteAccountStore.selectedReason.value = reason;
  }

  void openNextPage() {
    AppNavigator.toNamed(AppRouter.deleteAccountFinish);
  }
}
