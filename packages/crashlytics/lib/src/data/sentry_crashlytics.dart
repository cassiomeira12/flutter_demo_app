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
        options.anrEnabled = true;
        options.sendDefaultPii = true;
        options.attachScreenshot = true;
        options.attachStacktrace = true;
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
    CrashlyticsLogType type = CrashlyticsLogType.debug,
  }) {
    final breadcrumb = Breadcrumb(
      message: message,
      category: 'console',
      type: type.name,
      level: SentryLevel.fromName(level.name),
    );

    Sentry.addBreadcrumb(breadcrumb);
  }

  @override
  void logHttp(
    String message, {
    CrashlyticsLogLevel level = CrashlyticsLogLevel.debug,
    CrashlyticsLogType type = CrashlyticsLogType.http,
  }) {
    final breadcrumb = Breadcrumb(
      message: message,
      category: 'http',
      type: type.name,
      level: SentryLevel.fromName(level.name),
    );

    Sentry.addBreadcrumb(breadcrumb);
  }

  @override
  void logUserInteraction(
    String event, {
    Map<String, dynamic>? parameters,
    CrashlyticsLogLevel level = CrashlyticsLogLevel.debug,
    CrashlyticsLogType type = CrashlyticsLogType.user,
  }) {
    final breadcrumb = Breadcrumb(
      message: event,
      data: parameters,
      category: 'ui.User Interaction',
      type: type.name,
      level: SentryLevel.fromName(level.name),
    );

    Sentry.addBreadcrumb(breadcrumb);
  }

  @override
  Future<void> setUserId(String? userId) async {
    try {
      _user ??= SentryUser(id: userId);
      _user?.id = userId;
    } catch (_) {
      _user = null;
    }

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
  void setIpAddress(IpAddressLocationEntity ipAddress) {
    _user?.ipAddress = ipAddress.ip;

    _user?.geo = SentryGeo(
      countryCode: ipAddress.countryCode,
      city: ipAddress.city,
      region: ipAddress.region,
    );

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
    required String name,
    String? description,
    DateTime? startTimestamp,
  }) {
    return SentryTrackOperation(
      Sentry.startTransaction(
        name,
        name,
        description: description,
        startTimestamp: startTimestamp,
        waitForChildren: true,
      ),
    );
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
  final ISentrySpan _sentrySpan;
  bool finished = false;

  TrackOperationStatus _resultStatus = TrackOperationStatus.ok;

  SentryTrackOperation(
    ISentrySpan sentrySpan,
  ) : _sentrySpan = sentrySpan;

  @override
  TrackOperation startChild({
    required String name,
    String? description,
    DateTime? startTimestamp,
  }) {
    return SentryTrackOperation(
      _sentrySpan.startChild(
        name,
        description: description ?? name,
        startTimestamp: startTimestamp,
      ),
    );
  }

  @override
  void setData({
    required String key,
    required dynamic value,
  }) {
    _sentrySpan.setData(key, value);
  }

  @override
  void setStatus(TrackOperationStatus? status) {
    _resultStatus = status ?? TrackOperationStatus.ok;
  }

  @override
  void finish({DateTime? endTimestamp}) {
    if (finished) return;
    finished = true;
    _sentrySpan.finish(
      endTimestamp: endTimestamp,
      status: _parseSpanStatus,
    );
  }

  SpanStatus get _parseSpanStatus {
    switch (_resultStatus) {
      case TrackOperationStatus.ok:
        return const SpanStatus.ok();
      case TrackOperationStatus.cancelled:
        return const SpanStatus.cancelled();
      case TrackOperationStatus.internalError:
        return const SpanStatus.internalError();
      case TrackOperationStatus.unknownError:
        return const SpanStatus.unknownError();
      case TrackOperationStatus.notFound:
        return const SpanStatus.notFound();
      case TrackOperationStatus.alreadyExists:
        return const SpanStatus.alreadyExists();
      case TrackOperationStatus.permissionDenied:
        return const SpanStatus.permissionDenied();
      case TrackOperationStatus.aborted:
        return const SpanStatus.aborted();
      case TrackOperationStatus.unavailable:
        return const SpanStatus.unavailable();
      case TrackOperationStatus.dataLoss:
        return const SpanStatus.dataLoss();
      case TrackOperationStatus.unauthenticated:
        return const SpanStatus.unauthenticated();
    }
  }
}
