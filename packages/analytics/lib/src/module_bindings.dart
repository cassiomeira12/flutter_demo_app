import 'package:core/core.dart';

import 'data/data.dart';

class AnalyticsModuleBindings implements ModuleBinding {
  @override
  void injectDependencies() {
    AnalyticsServiceManager.instance.services.add(
      AptabaseAnalytics(
        apiKey: const String.fromEnvironment('analytics_aptabase_app_key'),
        apiUrl: const String.fromEnvironment('analytics_aptabase_host'),
      ),
    );
  }
}
