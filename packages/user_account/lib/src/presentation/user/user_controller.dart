import 'package:core/core.dart';

class UserController extends BaseController {
  UserEntity user = AppBinding.find();

  void changePassword() {
    AppNavigator.toNamed(AppRouter.changePassword);
  }

  void deleteAccount() {
    AppNavigator.toNamed(AppRouter.deleteAccount);
  }
}
