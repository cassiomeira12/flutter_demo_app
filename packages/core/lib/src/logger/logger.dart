// ignore_for_file: avoid_redundant_argument_values

import 'dart:io';

import 'package:core/core.dart' hide Platform;
import 'package:dependency/dependency.dart';

abstract class Log {
  static bool get isIntegrationTest {
    try {
      const String integrationTest = String.fromEnvironment(
        'INTEGRATION_TEST_SHOULD_REPORT_RESULTS_TO_NATIVE',
      );
      const bool isIntegrationTest = integrationTest == 'false';
      return isIntegrationTest;
    } catch (_) {
      return false;
    }
  }

  static bool get isUnitTest {
    try {
      return Platform.environment.containsKey('FLUTTER_TEST');
    } catch (_) {
      return false;
    }
  }

  static final _talker = Talker(
    settings: TalkerSettings(
      enabled: !isUnitTest && !kReleaseMode,
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
        level: CrashlyticsLogLevel.info,
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

  static void tracking(String msg) {
    if (!Log.isIntegrationTest) {
      final String message = '$_getClassNameAndPath \n\n$msg';
      _talker.warning(message);
    }
  }

  static void error(
    Object error,
    StackTrace? stackTrace, {
    String? msg,
    bool throwsCrashlytics = true,
  }) {
    final String functionName = _getClassNameAndPath.split(' ').first;
    _parseThrowsException(
      msg ?? functionName,
      error: error,
      stackTrace: stackTrace,
      throwsCrashlytics: throwsCrashlytics,
      isFatal: false,
    );
  }

  static void exception(
    Object error,
    StackTrace? stackTrace, {
    String? msg,
    bool throwsCrashlytics = true,
  }) {
    final String functionName = _getClassNameAndPath.split(' ').first;
    _parseThrowsException(
      msg ?? 'Exception $functionName',
      error: error,
      stackTrace: stackTrace,
      throwsCrashlytics: throwsCrashlytics,
      isFatal: true,
    );
  }

  static void baseException(
    BaseException error, {
    String? msg,
    bool throwsCrashlytics = true,
  }) {
    final String functionName = _getClassNameAndPath.split(' ').first;
    _parseThrowsException(
      msg ?? 'Exception $functionName',
      error: error,
      stackTrace: error.stackTrace,
      throwsCrashlytics: throwsCrashlytics,
      isFatal: true,
    );
  }

  static void fatalException(
    Object error,
    StackTrace stackTrace, {
    String? msg,
    bool throwsCrashlytics = true,
  }) {
    final String functionName = _getClassNameAndPath.split(' ').first;
    _parseThrowsException(
      msg ?? 'Fatal Exception $functionName',
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
      final bool ignoreCrashlytics = !line.contains('crashlytics_service');
      final bool ignoreDartIterable = !line.contains('iterable.dart');
      final bool ignoreDartAsync = !line.contains('dart:async');
      final bool ignoreDartCore = !line.contains('dart:core');
      final bool ignoreDartSdk = !line.contains('dart-sdk');
      return ignoreLogger &&
          ignoreAnalytics &&
          ignoreCrashlytics &&
          ignoreDartIterable &&
          ignoreDartAsync &&
          ignoreDartCore &&
          ignoreDartSdk;
    }

    // gets the first one that is not from this file
    final stackTraceLine = stackTraceLines.firstWhere(
      ignoreStackClass,
      orElse: () => '',
    );

    if (kIsWeb) {
      final splitStackTrace = stackTraceLine.split(' ');
      if (splitStackTrace.isEmpty) return stackTraceLine;
      final package = splitStackTrace.first.contains('package:')
          ? splitStackTrace.first
          : 'package:${splitStackTrace.first}';
      final line = splitStackTrace[1];
      final functionName = splitStackTrace.last;
      return '$functionName ($package:$line)';
    }

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
