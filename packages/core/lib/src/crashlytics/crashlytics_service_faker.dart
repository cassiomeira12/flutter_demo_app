import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class CrashlyticsServiceFaker implements CrashlyticsService {
  @override
  Future<void> init() async {
    Log.success('$runtimeType init', throwsCrashlytics: false);
  }

  @override
  void log(String message) {}

  @override
  Future<void> setUserId(String userId) async {}

  @override
  Future<void> setUserProperty({
    required String name,
    required Map<String, dynamic> property,
  }) async {}

  @override
  Future<void> captureException({
    required Object error,
    StackTrace? stackTrace,
  }) async {}

  @override
  Future<void> captureFatalException({
    required Object error,
    StackTrace? stackTrace,
  }) async {}
}
