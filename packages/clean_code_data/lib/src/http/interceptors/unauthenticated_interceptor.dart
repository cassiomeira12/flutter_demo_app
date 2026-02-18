import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class UnauthenticatedInterceptor extends Interceptor with AnalyticsMixin {
  final AppSecurityManager _appSecurityManager;
  final LocalStorageUseCase _localStorageUseCase;

  UnauthenticatedInterceptor({
    required AppSecurityManager appSecurityManager,
    required LocalStorageUseCase localStorageUseCase,
  }) : _appSecurityManager = appSecurityManager,
       _localStorageUseCase = localStorageUseCase;

  static bool ALREADY_LOGOUT = false;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.type == DioExceptionType.badResponse) {
      try {
        final Map<String, dynamic> body = err.response?.data ?? {};

        final errorMessages = [
          'Invalid session token',
          'Session token is expired.',
        ];

        final bool invalidTokenCode = body['code'] == 209;
        final bool invalidTokenError = errorMessages.contains(
          '${body['error']}',
        );

        if (!ALREADY_LOGOUT && invalidTokenCode && invalidTokenError) {
          ALREADY_LOGOUT = true;

          sessionExpiredTagging();

          await SessionHelper.clear();
          await _appSecurityManager.clearSettings();
          await _appSecurityManager.init();

          await _localStorageUseCase.set<bool>(SESSION_WAS_EXPIRED, true);

          AppNavigator.backAllAndToNamed(AppRouter.splash);
        }
      } catch (error, stacktrace) {
        Log.error(
          'UnauthenticatedInterceptor',
          error: error,
          stackTrace: stacktrace,
        );
      }
    }

    return super.onError(err, handler);
  }
}
