import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class Log {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 15,
      dateTimeFormat: (time) {
        return 'Time: ${DateHelper.formatHourMinuteSeconds(time)}h';
      },
      // excludePaths: ['package:flutter_demo_app/core/logger/logger.dart'],
    ),
  );

  static final _talker = Talker(
    settings: TalkerSettings(
      timeFormat: TimeFormat.yearMonthDayAndTime,
      colors: {
        TalkerKey.info: AnsiPen()..cyan(),
        TalkerKey.verbose: AnsiPen()..green(),
        TalkerKey.debug: AnsiPen()..blue(),
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
    // _logger.i(message, time: DateTime.now());
    _talker.info(message);
  }

  static void success(String msg, {bool throwsCrashlytics = true}) {
    final String message = '$_getClassNameAndPath \n\n$msg';
    // _logger.d(message, time: DateTime.now());
    _talker.verbose(message);
    if (throwsCrashlytics) {
      CrashlyticsServiceManager.instance.log(message);
    }
  }

  static void debug(String msg, {bool throwsCrashlytics = true}) {
    final String message = '$_getClassNameAndPath \n\n$msg';
    // _logger.d(message, time: DateTime.now());
    _talker.debug(message);
    if (throwsCrashlytics) {
      CrashlyticsServiceManager.instance.log(message);
    }
  }

  static void warning(String msg, {bool throwsCrashlytics = true}) {
    final String message = '$_getClassNameAndPath \n\n$msg';
    // _logger.w(message, time: DateTime.now());
    _talker.warning(message);
    if (throwsCrashlytics) {
      CrashlyticsServiceManager.instance.log(message);
    }
  }

  static void error(
    String msg, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
    BaseException? exception,
    bool throwsCrashlytics = true,
  }) {
    final String message = '$_getClassNameAndPath \n\n$msg';
    // _logger.e(
    //   message,
    //   time: DateTime.now(),
    //   error: error ?? exception?.error,
    //   stackTrace: stackTrace ?? exception?.stacktrace,
    // );
    _talker.error(message, exception, stackTrace);
    if (throwsCrashlytics) {
      _captureException(
        error: error,
        stackTrace: stackTrace,
        exception: exception,
      );
    }
  }

  static void fatalError(
    String msg, {
    DateTime? time,
    required Object error,
    StackTrace? stackTrace,
    bool throwsCrashlytics = true,
  }) {
    final String message = '$_getClassNameAndPath \n\n$msg';
    // _logger.f(
    //   message,
    //   time: DateTime.now(),
    //   error: error,
    //   stackTrace: stackTrace,
    // );
    _talker.critical(message, error, stackTrace);
    if (throwsCrashlytics) {
      _captureException(error: error, stackTrace: stackTrace, isFatal: true);
    }
  }

  static void _captureException({
    Object? error,
    StackTrace? stackTrace,
    BaseException? exception,
    bool isFatal = false,
  }) {
    if (kDebugMode) return;
    if (error == null && exception?.error == null) return;
    if (isFatal) {
      CrashlyticsServiceManager.instance.captureFatalException(
        error: error ?? exception?.error,
        stackTrace: stackTrace ?? exception?.stacktrace,
      );
    } else {
      CrashlyticsServiceManager.instance.captureException(
        error: error ?? exception?.error,
        stackTrace: stackTrace ?? exception?.stacktrace,
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
