import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'admin_user_details.dart';

class AdminUserDetailsBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<AdminUserDetailsController>(
      AdminUserDetailsController(userStore: AppBinding.find()),
    );
  }
}
