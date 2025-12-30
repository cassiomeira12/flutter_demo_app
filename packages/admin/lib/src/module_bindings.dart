import 'package:core/core.dart';

import 'presentation/presentation.dart';

class AdminModuleBindings implements ModuleBinding {
  @override
  void injectDependencies() {
    AppBinding.put<UsersStore>(UsersStore(), permanent: true);
  }
}
