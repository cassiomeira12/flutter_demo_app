import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'user.dart';

class UserBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<UserController>(UserController());
  }
}
