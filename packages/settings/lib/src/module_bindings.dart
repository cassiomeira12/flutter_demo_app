import 'package:core/core.dart';
import 'package:faq/faq.dart';
import 'package:security/security.dart';
import 'package:user_account/user_account.dart';

class SettingsModuleBindings implements ModuleBinding {
  @override
  Future<void> injectDependencies() async {
    UserAccountModuleBindings().injectDependencies();
    SecurityModuleBindings().injectDependencies();
    FaqModuleBindings().injectDependencies();
  }
}
