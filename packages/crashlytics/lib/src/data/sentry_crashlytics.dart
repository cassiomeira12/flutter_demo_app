import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class SentryCrashlytics implements CrashlyticsService {
  final String apiUrl;

  SentryCrashlytics({required this.apiUrl});

  SentryUser? _user;

  @override
  Future<void> init() async {
    await SentryFlutter.init((options) {
      options.dsn = apiUrl;
      options.anrEnabled = true;
      options.debug = false;
      options.sampleRate = 1.0;
      options.tracesSampleRate = 1.0;
      options.attachScreenshot = true;
      options.enableTimeToFullDisplayTracing = true;
      options.reportSilentFlutterErrors = true;
    });
  }

  @override
  void log(String message) {
    final breadcrumb = Breadcrumb(message: message);

    Sentry.addBreadcrumb(breadcrumb);
  }

  @override
  Future<void> setUserId(String userId) async {
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
    required Object error,
    StackTrace? stackTrace,
  }) async {
    await Sentry.captureException(error, stackTrace: stackTrace);
  }

  @override
  Future<void> captureFatalException({
    required Object error,
    StackTrace? stackTrace,
  }) async {
    await Sentry.captureException(error, stackTrace: stackTrace);
  }

  @override
  TrackOperation trackOperation({String? name, String? operation}) {
    final track = Sentry.startTransaction(
      name ?? 'name',
      operation ?? 'operation',
    );
    return SentryTrackOperation(track: track);
  }
}

class SentryTrackOperation implements TrackOperation {
  final ISentrySpan track;
  bool _catchError = false;

  SentryTrackOperation({required this.track});

  @override
  TrackOperation startChild({String? operation}) {
    final trackChild = track.startChild(operation ?? 'operation');
    return SentryTrackOperation(track: trackChild);
  }

  @override
  void catchError({Object? error}) {
    track.throwable = error;
    _catchError = error != null;
  }

  @override
  void finish() {
    track.finish(
      status: _catchError
          ? const SpanStatus.internalError()
          : const SpanStatus.ok(),
    );
  }
}
