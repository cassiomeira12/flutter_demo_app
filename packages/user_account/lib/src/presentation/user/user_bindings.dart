import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:user_account/src/presentation/user/user.dart';

class UserBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<UserController>(UserController());
  }
}
