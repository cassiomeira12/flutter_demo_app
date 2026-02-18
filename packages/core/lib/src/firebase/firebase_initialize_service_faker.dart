import 'package:core/core.dart';

class FirebaseInitializeServiceFaker implements FirebaseInitializeService {
  @override
  Future<void> init() async {
    Log.success('$runtimeType init', throwsCrashlytics: false);
  }

  @override
  String get messagingSenderId =>
      const String.fromEnvironment('firebaseMessagingSenderId');
}
