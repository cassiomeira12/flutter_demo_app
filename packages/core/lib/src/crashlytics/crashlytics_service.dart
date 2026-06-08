import 'dart:developer' as developer;

import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

abstract class CrashlyticsService {
  Future<void> init();

  Future<void> updateInitSettings();

  Future<void> setUserId(String? userId);

  Future<void> setUserProperty({
    required String name,
    required Map<String, dynamic> property,
  });

  void setIpAddress(IpAddressLocationEntity ipAddress);

  void log(
    String message, {
    CrashlyticsLogLevel level = CrashlyticsLogLevel.debug,
    CrashlyticsLogType type = CrashlyticsLogType.debug,
  });

  void logHttp(
    String message, {
    CrashlyticsLogLevel level = CrashlyticsLogLevel.debug,
    CrashlyticsLogType type = CrashlyticsLogType.http,
  });

  void logUserInteraction(
    String event, {
    Map<String, dynamic>? parameters,
    CrashlyticsLogLevel level = CrashlyticsLogLevel.debug,
    CrashlyticsLogType type = CrashlyticsLogType.user,
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
    required String name,
    String? description,
    DateTime? startTimestamp,
  });

  void simulateCrash();

  static Widget wrapperWidget(Widget child) {
    return SentryWidget(child: child);
  }

  static R? zonedGuarded<R>(
    R Function() body, {
    void Function(Object error, StackTrace? stack)? onError,
  }) {
    return Sentry.runZonedGuarded<R>(
      body,
      onError ?? CrashlyticsService.catchException,
    );
  }

  static void catchFlutterError(FlutterErrorDetails details) {
    Log.fatalException(
      details.exception,
      details.stack ?? StackTrace.current,
      msg: 'Flutter Error',
    );
    developer.debugger();
  }

  static bool catchException(Object error, StackTrace stackTrace) {
    final bool memoryError = error.toString().contains('memory');
    final bool disposeError = error.toString().contains('dispose');
    if (memoryError || disposeError) {
      Log.fatalException(error, stackTrace, msg: 'Potential Memory Leak');
    } else {
      Log.fatalException(error, stackTrace, msg: 'Unexpected Error');
    }
    developer.debugger();
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

enum CrashlyticsLogType {
  http,
  debug,
  user,
  navigation,
}
