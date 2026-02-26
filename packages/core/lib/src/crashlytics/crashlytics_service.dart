import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

abstract class CrashlyticsService {
  Future<void> init();

  Future<void> setUserId(String? userId);

  Future<void> setUserProperty({
    required String name,
    required Map<String, dynamic> property,
  });

  void log(
    String message, {
    CrashlyticsLogLevel level = CrashlyticsLogLevel.debug,
  });

  Future<void> captureException({
    String? message,
    required Object error,
    StackTrace? stackTrace,
  });

  Future<void> captureFatalException({
    String? message,
    required Object error,
    StackTrace? stackTrace,
  });

  TrackOperation trackOperation({
    String? name,
    String? operation,
    DateTime? startTimestamp,
  });

  void simulateCrash();

  static void catchFlutterError(FlutterErrorDetails details) {
    catchException(details.exception, details.stack);
  }

  static bool catchException(Object error, StackTrace? stackTrace) {
    final bool memoryError = error.toString().contains('memory');
    final bool disposeError = error.toString().contains('dispose');
    if (memoryError || disposeError) {
      Log.fatalError(
        'potential memory leak',
        error: error,
        stackTrace: stackTrace,
      );
      return true;
    }
    Log.fatalError('catchException', error: error, stackTrace: stackTrace);
    return true;
  }
}

enum CrashlyticsLogLevel {
  info,
  debug,
  warning,
  error,
  fatal,
}
