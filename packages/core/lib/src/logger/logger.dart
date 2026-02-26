// ignore_for_file: avoid_redundant_argument_values

import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class Log {
  static final _talker = Talker(
    settings: TalkerSettings(
      enabled: !kReleaseMode,
      timeFormat: TimeFormat.yearMonthDayAndTime,
      colors: {
        TalkerKey.info: AnsiPen()..cyan(),
        TalkerKey.verbose: AnsiPen()..green(),
        TalkerKey.debug: AnsiPen()..blue(),
        TalkerKey.warning: AnsiPen()..yellow(),
        TalkerKey.error: AnsiPen()..red(),
        TalkerKey.critical: AnsiPen()..red(),
      },
      titles: {
        TalkerKey.info: 'Log Info',
        TalkerKey.verbose: 'Log Success',
        TalkerKey.debug: 'Log Debug',
        TalkerKey.warning: 'Log Warning',
        TalkerKey.error: 'Log Error',
        TalkerKey.critical: 'Log Fatal Error',
      },
    ),
  );

  static void info(String msg) {
    final String message = '$_getClassNameAndPath \n\n$msg';
    _talker.info(message);
  }

  static void success(String msg, {bool throwsCrashlytics = true}) {
    final String message = '$_getClassNameAndPath \n\n$msg';
    _talker.verbose(message);
    if (throwsCrashlytics) {
      CrashlyticsServiceManager.instance.log(
        message,
        level: CrashlyticsLogLevel.debug,
      );
    }
  }

  static void debug(String msg, {bool throwsCrashlytics = true}) {
    final String message = '$_getClassNameAndPath \n\n$msg';
    _talker.debug(message);
    if (throwsCrashlytics) {
      CrashlyticsServiceManager.instance.log(
        message,
        level: CrashlyticsLogLevel.debug,
      );
    }
  }

  static void warning(String msg, {bool throwsCrashlytics = true}) {
    final String message = '$_getClassNameAndPath \n\n$msg';
    _talker.warning(message);
    if (throwsCrashlytics) {
      CrashlyticsServiceManager.instance.log(
        message,
        level: CrashlyticsLogLevel.warning,
      );
    }
  }

  static void error(
    String msg, {
    Object? error,
    StackTrace? stackTrace,
    bool throwsCrashlytics = true,
  }) {
    _parseThrowsException(
      msg,
      error: error,
      stackTrace: stackTrace,
      throwsCrashlytics: throwsCrashlytics,
      isFatal: false,
    );
  }

  static void fatalError(
    String msg, {
    Object? error,
    StackTrace? stackTrace,
    bool throwsCrashlytics = true,
  }) {
    _parseThrowsException(
      msg,
      error: error,
      stackTrace: stackTrace,
      throwsCrashlytics: throwsCrashlytics,
      isFatal: true,
    );
  }

  static void _parseThrowsException(
    String msg, {
    required Object? error,
    required StackTrace? stackTrace,
    required bool throwsCrashlytics,
    required bool isFatal,
  }) {
    String message = '$_getClassNameAndPath\n';
    if (msg.isNotEmpty) message += '$msg\n';

    Object? internalError = error;
    StackTrace? internalStackTrace = stackTrace;
    bool throwsToCrashlytics = throwsCrashlytics;

    if (error is BaseException) {
      internalError = error.error ?? error;
      internalStackTrace = error.stackTrace ?? stackTrace;
      throwsToCrashlytics = error.throwReport;
    }

    if (isFatal) {
      _talker.critical(message, internalError, internalStackTrace);
    } else {
      _talker.error(message, internalError, internalStackTrace);
    }

    if (throwsToCrashlytics) {
      _captureException(
        message: msg,
        error: internalError,
        stackTrace: internalStackTrace,
        isFatal: isFatal,
      );
    }
  }

  static void _captureException({
    required String message,
    Object? error,
    StackTrace? stackTrace,
    bool isFatal = false,
  }) {
    if (error == null) {
      return CrashlyticsServiceManager.instance.log(
        message,
        level: isFatal ? CrashlyticsLogLevel.fatal : CrashlyticsLogLevel.error,
      );
    }

    if (isFatal) {
      CrashlyticsServiceManager.instance.captureFatalException(
        message: message,
        error: error,
        stackTrace: stackTrace,
      );
    } else {
      CrashlyticsServiceManager.instance.captureException(
        message: message,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static String get _getClassNameAndPath {
    final stackTrace = StackTrace.current;
    final stackTraceLines = stackTrace.toString().split('\n');

    bool ignoreStackClass(String line) {
      final bool ignoreLogger = !line.contains('logger.dart');
      final bool ignoreAnalytics = !line.contains('analytics_mixin.dart');
      return ignoreLogger && ignoreAnalytics;
    }

    // gets the first one that is not from this file
    final stackTraceLine = stackTraceLines.firstWhere(
      ignoreStackClass,
      orElse: () => '',
    );
    final classAndMethodName =
        RegExp(r'\b([\w]+\.[\w]+)\b').firstMatch(stackTraceLine)?.group(1) ??
        '';
    final stackTraceLineWithoutBlankSpace = stackTraceLine.replaceFirst(
      RegExp(r'^.*\s'),
      '',
    );
    return '$classAndMethodName $stackTraceLineWithoutBlankSpace';
  }
}
