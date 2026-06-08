import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';

class UserController extends BaseController {
  final UserEntity _user;

  UserController({required this._user});

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
