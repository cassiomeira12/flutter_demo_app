import 'package:core/core.dart';
import 'package:faq/faq.dart';
import 'package:security/security.dart';
import 'package:user_account/user_account.dart';

class SettingsModuleBindings implements ModuleBinding {
  @override
  void injectDependencies() {
    UserAccountModuleBindings().injectDependencies();
    SecurityModuleBindings().injectDependencies();
    FaqModuleBindings().injectDependencies();
  }
}
