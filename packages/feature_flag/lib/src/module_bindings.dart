import 'package:core/core.dart';
import 'package:feature_flag/src/data/data.dart';

class FeatureFlagModuleBindings implements ModuleBinding {
  @override
  Future<void> injectDependencies() async {
    FeatureFlagServiceManager.instance.services.add(
      FlagsmithFeatureFlag(
        apiKey: const String.fromEnvironment('remote_config_flagsmith_key'),
        baseURI: const String.fromEnvironment('remote_config_flagsmith_host'),
        initialConfigJson: AppAssets.flagsmithInitialOfflineConfigs,
        localStorageUseCase: AppBinding.find(),
      ),
    );
  }
}
