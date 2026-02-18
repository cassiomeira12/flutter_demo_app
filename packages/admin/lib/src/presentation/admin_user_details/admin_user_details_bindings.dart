import 'package:admin/src/presentation/admin_user_details/admin_user_details.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class AdminUserDetailsBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<AdminUserDetailsController>(
      AdminUserDetailsController(userStore: AppBinding.find()),
    );
  }
}
