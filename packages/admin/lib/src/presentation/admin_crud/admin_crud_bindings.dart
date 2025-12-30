import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'admin_crud.dart';

class AdminCrudBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<AdminCrudController>(AdminCrudController());
  }
}
