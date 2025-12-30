import 'package:core/core.dart';

class DeleteAccountFinishController extends BaseController {
  void openNextPage() {
    AppNavigator.toNamed(AppRouter.deleteAccountConfirmation);
  }
}
