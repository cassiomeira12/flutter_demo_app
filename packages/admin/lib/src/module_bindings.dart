import 'package:admin/src/presentation/presentation.dart';
import 'package:core/core.dart';

class AdminModuleBindings implements ModuleBinding {
  @override
  Future<void> injectDependencies() async {
    AppBinding.put<UsersStore>(UsersStore(), permanent: true);
  }
}
