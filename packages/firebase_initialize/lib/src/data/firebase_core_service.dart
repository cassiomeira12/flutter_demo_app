import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseCoreService implements FirebaseInitializeService {
  final String _projectId;
  final String _apiKey;
  final String _appId;
  final String _senderId;

  FirebaseCoreService({
    required String projectId,
    required String apiKey,
    required String appId,
    required String senderId,
  }) : _projectId = projectId,
       _apiKey = apiKey,
       _appId = appId,
       _senderId = senderId;

  FirebaseApp? _app;

  @override
  Future<void> init() async {
    try {
      final FirebaseOptions? options = Platform.isWeb
          ? FirebaseOptions(
              projectId: _projectId,
              apiKey: _apiKey,
              appId: _appId,
              messagingSenderId: _senderId,
            )
          : null;
      _app = await Firebase.initializeApp(options: options);
      Log.success('$runtimeType init successful', throwsCrashlytics: false);
    } catch (error, stackTrace) {
      Log.error(
        '$runtimeType init ERROR',
        error: error,
        stackTrace: stackTrace,
        throwsCrashlytics: false,
      );
    }
  }

  @override
  String get messagingSenderId =>
      _app?.options.messagingSenderId ??
      const String.fromEnvironment('firebaseMessagingSenderId');
}
