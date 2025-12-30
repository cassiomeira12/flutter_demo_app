import 'package:core/core.dart';

import '../presentation.dart';

class AdminUserDetailsController extends BaseController {
  final UsersStore _usersStore;

  AdminUserDetailsController({required UsersStore userStore})
    : _usersStore = userStore;

  UserEntity get user {
    return _usersStore.userSelected!;
  }

  void changePassword() {
    AppNavigator.toNamed(AppRouter.changePassword);
  }

  void deleteAccount() {
    AppNavigator.toNamed(AppRouter.deleteAccount);
  }

  void openUserInstallations() {
    //
  }
}
