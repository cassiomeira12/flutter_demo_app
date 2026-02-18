import 'package:admin/src/presentation/admin_crud/admin_crud.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class AdminCrudBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<AdminCrudController>(AdminCrudController());
  }
}
