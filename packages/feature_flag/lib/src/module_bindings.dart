import 'package:core/core.dart';

import 'data/flagsmith/flagsmith.dart';

class FeatureFlagModuleBindings implements ModuleBinding {
  @override
  void injectDependencies() {
    AppBinding.replace<FeatureFlagService>(
      FlagsmithFeatureFlag(
        apiKey: const String.fromEnvironment('remote_config_flagsmith_key'),
        baseURI: const String.fromEnvironment('remote_config_flagsmith_host'),
        initialConfigJson: AppAssets.flagsmithInitialOfflineConfigs,
        localStorageUseCase: AppBinding.find(),
      ),
    );
  }
}
