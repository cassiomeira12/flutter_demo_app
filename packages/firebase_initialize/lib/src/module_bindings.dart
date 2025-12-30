import 'package:core/core.dart';

import 'data/firebase_core_service.dart';

class FirebaseInitializeModuleBindings implements ModuleBinding {
  @override
  void injectDependencies() {
    AppBinding.replace<FirebaseInitializeService>(
      FirebaseCoreService(
        projectId: const String.fromEnvironment('firebaseProjectId'),
        apiKey: const String.fromEnvironment('firebaseApiKey'),
        appId: const String.fromEnvironment('firebaseAppId'),
        senderId: const String.fromEnvironment('firebaseMessagingSenderId'),
      ),
    );
  }
}
