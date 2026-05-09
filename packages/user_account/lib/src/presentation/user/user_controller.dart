import 'package:core/core.dart';

class UserController extends BaseController {
  final UserEntity _user;

  UserController({
    required UserEntity user,
  }) : _user = user;

  String get avatarUrl => _user.avatarUrl;
  String get userName => _user.name;
  String get userEmail => _user.email;

  void changePassword() {
    AppNavigator.toNamed(AppRouter.changePassword);
  }

  void deleteAccount() {
    AppNavigator.toNamed(AppRouter.deleteAccount);
  }
}
