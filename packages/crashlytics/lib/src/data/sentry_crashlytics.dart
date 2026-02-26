import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class SentryCrashlytics implements CrashlyticsService {
  final String apiUrl;

  SentryCrashlytics({required this.apiUrl});

  SentryUser? _user;

  @override
  Future<void> init() async {
    await SentryFlutter.init(
      (options) {
        options.dsn = apiUrl;
        options.debug = !kReleaseMode;
        options.sampleRate = 1.0;
        options.tracesSampleRate = 1.0;
        options.profilesSampleRate = 1.0;
        options.anrEnabled = true;
        options.sendDefaultPii = true;
        options.attachScreenshot = true;
        options.attachViewHierarchy = true;
        options.enablePrintBreadcrumbs = true;
        options.reportSilentFlutterErrors = true;
        options.enableTimeToFullDisplayTracing = true;
      },
    );
  }

  @override
  void log(
    String message, {
    CrashlyticsLogLevel level = CrashlyticsLogLevel.debug,
  }) {
    final breadcrumb = Breadcrumb(
      message: message,
      level: SentryLevel.fromName(level.name),
    );

    Sentry.addBreadcrumb(breadcrumb);
  }

  @override
  Future<void> setUserId(String? userId) async {
    _user ??= SentryUser(id: userId);
    _user?.id = userId;

    Sentry.configureScope((scope) => scope.setUser(_user));
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required Map<String, dynamic> property,
  }) async {
    _user ??= SentryUser(name: name);

    _user?.id = property['userId'];
    _user?.name = name;
    _user?.username = property['username'];
    _user?.email = property['email'];
    _user?.ipAddress = property['ipAddress'];

    property
      ..remove('userId')
      ..remove('name')
      ..remove('username')
      ..remove('email')
      ..remove('ipAddress');

    _user?.data = property;

    Sentry.configureScope((scope) => scope.setUser(_user));
  }

  @override
  Future<void> captureException({
    String? message,
    required Object error,
    StackTrace? stackTrace,
  }) async {
    await Sentry.captureException(
      error,
      stackTrace: stackTrace,
      message: message == null ? null : SentryMessage(message),
    );
  }

  @override
  Future<void> captureFatalException({
    String? message,
    required Object error,
    StackTrace? stackTrace,
  }) async {
    await Sentry.captureException(
      error,
      stackTrace: stackTrace,
      message: message == null ? null : SentryMessage(message),
    );
  }

  @override
  TrackOperation trackOperation({
    String? name,
    String? operation,
    DateTime? startTimestamp,
  }) {
    final track = Sentry.startTransaction(
      name ?? 'name',
      operation ?? 'operation',
      startTimestamp: startTimestamp,
    );
    return SentryTrackOperation(track: track, operation: operation);
  }

  @override
  void simulateCrash() {
    Sentry.captureException(
      SentryException(value: null, type: null),
      message: SentryMessage('Simulate Crash'),
    );
  }
}

class SentryTrackOperation implements TrackOperation {
  final ISentrySpan track;
  final String? _parentOperation;

  bool _catchError = false;

  SentryTrackOperation({
    required this.track,
    String? operation,
  }) : _parentOperation = operation;

  @override
  TrackOperation startChild({
    required String operation,
    DateTime? startTimestamp,
  }) {
    final trackChild = track.startChild(
      operation,
      description: _parentOperation,
      startTimestamp: startTimestamp,
    );
    return SentryTrackOperation(track: trackChild);
  }

  @override
  void catchError({Object? error}) {
    track.throwable = error;
    _catchError = error != null;
  }

  @override
  void finish({DateTime? endTimestamp}) {
    track.finish(
      endTimestamp: endTimestamp,
      status: _catchError
          ? const SpanStatus.internalError()
          : const SpanStatus.ok(),
    );
  }
}
