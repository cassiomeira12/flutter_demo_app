import 'package:analytics/src/data/data.dart';
import 'package:core/core.dart';

class AnalyticsModuleBindings implements ModuleBinding {
  @override
  Future<void> injectDependencies() async {
    AnalyticsServiceManager.instance.services.add(
      AptabaseAnalytics(
        apiKey: const String.fromEnvironment('analytics_aptabase_app_key'),
        apiUrl: const String.fromEnvironment('analytics_aptabase_host'),
      ),
    );
  }
}
