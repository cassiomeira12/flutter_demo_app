import 'package:core/core.dart';
import 'package:crashlytics/src/data/data.dart';

class CrashlyticsModuleBindings implements ModuleBinding {
  @override
  Future<void> injectDependencies() async {
    CrashlyticsServiceManager.instance.services.add(
      SentryCrashlytics(
        apiUrl: const String.fromEnvironment('crashlytics_sentry_dsn'),
      ),
    );
  }
}
