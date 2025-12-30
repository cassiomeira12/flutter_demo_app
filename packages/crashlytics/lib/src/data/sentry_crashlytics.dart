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
}
