import 'package:appsflyer/src/data/appsflyer_service.dart';
import 'package:core/core.dart';

class AppsFlyerModuleBindings implements ModuleBinding {
  @override
  Future<void> injectDependencies() async {
    await AppBinding.replace<AppsFlyerService>(
      AppsflyerServiceImpl(
        afDevKey: const String.fromEnvironment('appsflyer_af_dev_key'),
        appleStoreAppId: const String.fromEnvironment('apple_store_app_id'),
      ),
    );
  }
}
