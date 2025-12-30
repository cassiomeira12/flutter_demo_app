import 'package:core/core.dart';

import 'data/data.dart';

class CrashlyticsModuleBindings implements ModuleBinding {
  @override
  void injectDependencies() {
    CrashlyticsServiceManager.instance.services.add(
      SentryCrashlytics(
        apiUrl: const String.fromEnvironment('crashlytics_sentry_dsn'),
      ),
    );
  }
}
